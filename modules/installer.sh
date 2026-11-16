#!/data/data/com.termux/files/usr/bin/bash
termux_package_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q 'install ok installed'; }
ensure_proot_distro() {
  if command -v proot-distro >/dev/null 2>&1; then
    ui_ok "proot-distro is available"
    return 0
  fi
  ui_warn "proot-distro is not installed. It is required to create Linux environments."
  confirm "Install proot-distro now?" || die "Installation cancelled by user."
  ui_step "Updating Termux package lists"
  pkg update -y || die "Could not update Termux package lists. Check your internet connection and try again."
  ui_step "Installing proot-distro"
  pkg install -y proot-distro || die "proot-distro installation failed. Check the output above and try again."
  command -v proot-distro >/dev/null 2>&1 || die "proot-distro is still unavailable after installation."
  ui_ok "proot-distro installed"
}
check_termux_dependencies() {
  ensure_proot_distro
  local -a required=(pulseaudio)
  local -a missing=()
  local package
  for package in "${required[@]}"; do
    termux_package_installed "$package" || missing+=("$package")
  done
  if (( ${#missing[@]} )); then
    ui_step "Installing Termux dependencies: ${missing[*]}"
    pkg install -y "${missing[@]}" || die "Could not install Termux dependencies. Run redmux install again after fixing the package error."
  else
    ui_ok "Termux dependencies are ready"
  fi
}
check_storage() {
  local available
  available="$(df -Pk "$HOME" | awk 'NR==2 {print $4}')"
  if [[ "$available" =~ ^[0-9]+$ ]] && (( available < 2500000 )); then
    ui_warn "Less than 2.5 GB of free storage is available. A desktop environment may need more space."
    confirm "Continue anyway?" || return 1
  fi
}
select_install_distro() {
  local selected
  selected="$(choose "Select a Linux distribution:" "Debian" "Ubuntu" "Kali Linux")"
  case "$selected" in
    Debian) REDMUX_DISTRO=debian;;
    Ubuntu) REDMUX_DISTRO=ubuntu;;
    "Kali Linux") REDMUX_DISTRO=kali;;
    *) die "Invalid distribution selection.";;
  esac
}
install_guest_packages() {
  local packages="$1"
  proot-distro login --shared-tmp "$REDMUX_DISTRO" -- /bin/bash -s <<GUEST
set -e
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
apt-get update
 dpkg --configure -a
apt-get --fix-broken install -y
packages="$packages"
missing=""
for package in \$packages; do
  status="\$(dpkg-query -W -f='\${Status}' "\$package" 2>/dev/null || true)"
  if [ "\$status" != "install ok installed" ]; then
    missing="\$missing \$package"
  fi
done
if [ -n "\$missing" ]; then
  apt-get -o Dpkg::Progress-Fancy=1 -o APT::Color=0 install -y \$missing
fi
dpkg --configure -a
GUEST
}
run_installer() {
  require_termux
  check_storage || return
  ui_banner
  ui_section "PRE-INSTALLATION CHECKS"
  check_termux_dependencies
  select_install_distro
  REDMUX_DESKTOPS="$(desktop_select_many)"
  REDMUX_DESKTOP="${REDMUX_DESKTOPS%%,*}"
  save_config
  state_init "$REDMUX_DISTRO" "$REDMUX_DESKTOPS" || return 1
  local total=5
  ui_summary "$REDMUX_DISTRO" "$REDMUX_DESKTOPS"
  if ! state_has 1; then
    if distro_installed "$REDMUX_DISTRO"; then
      ui_ok "$REDMUX_DISTRO is already installed; skipping root filesystem download"
    else
      ui_stage 1 "$total" "Installing Linux root filesystem"
      if ! proot-distro install "$REDMUX_DISTRO"; then
        ui_fail "Linux root filesystem installation failed"
        ui_warn "Check the network connection, then run redmux install to retry."
        return 1
      fi
    fi
    state_mark 1
    ui_ok "Linux distribution is ready"
  else
    ui_ok "Linux distribution stage already completed"
  fi
  if ! state_has 2; then
    ui_stage 2 "$total" "Preparing the Linux package manager"
    if ! proot-distro login --shared-tmp "$REDMUX_DISTRO" -- /bin/bash -lc 'export DEBIAN_FRONTEND=noninteractive; export NEEDRESTART_MODE=a; apt-get update && dpkg --configure -a && apt-get --fix-broken install -y'; then
      ui_fail "Could not prepare APT inside $REDMUX_DISTRO"
      ui_warn "The command output above contains the package-manager error. Fix the reported issue and run redmux install again."
      return 1
    fi
    state_mark 2
    ui_ok "Linux package manager is ready"
  else
    ui_ok "Linux package preparation already completed"
  fi
  local packages
  packages="$(desktop_packages | sort -u | tr '\n' ' ')"
  if ! state_has 3; then
    ui_stage 3 "$total" "Installing desktop environment packages"
    if ! install_guest_packages "$packages"; then
      ui_fail "Desktop package installation failed"
      ui_warn "APT can reuse downloaded packages. Fix the error above and run redmux install again."
      return 1
    fi
    state_mark 3
    ui_ok "Desktop packages installed"
  else
    ui_ok "Desktop package installation already completed"
  fi
  if ! state_has 4; then
    ui_stage 4 "$total" "Verifying desktop components"
    local desktop
    for desktop in ${REDMUX_DESKTOPS//,/ }; do
      if ! desktop_installed "$desktop"; then
        ui_fail "Desktop component check failed: $desktop"
        ui_warn "Run redmux install again to retry the verification and installation stages."
        return 1
      fi
    done
    state_mark 4
    ui_ok "Selected desktop environments verified"
  else
    ui_ok "Desktop verification already completed"
  fi
  if ! state_has 5; then
    ui_stage 5 "$total" "Preparing Termux:X11"
    if ! x11_prepare; then
      ui_fail "Termux:X11 setup failed"
      return 1
    fi
    state_mark 5
    ui_ok "Termux:X11 command-line tools are ready"
  else
    ui_ok "Termux:X11 setup already completed"
  fi
  save_config
  state_clear
  ui_complete "$REDMUX_DISTRO" "$REDMUX_DESKTOPS"
}
