#!/data/data/com.termux/files/usr/bin/bash
desktop_name() {
  case "$1" in
    xfce) printf 'XFCE4';;
    kde) printf 'KDE Plasma';;
    lxqt) printf 'LXQt';;
    mate) printf 'MATE';;
    lxde) printf 'LXDE';;
    gnome) printf 'GNOME';;
    *) return 1;;
  esac
}
desktop_key() {
  case "$1" in
    1|xfce|XFCE4) printf 'xfce';;
    2|kde|KDE) printf 'kde';;
    3|lxqt|LXQt) printf 'lxqt';;
    4|mate|MATE) printf 'mate';;
    5|lxde|LXDE) printf 'lxde';;
    6|gnome|GNOME) printf 'gnome';;
    *) return 1;;
  esac
}
desktop_select_many() {
  local raw item key result='' index
  printf '%s\n' "Choose your desktop environment(s)." "Select multiple options with commas, for example: 1,3,4" "1) XFCE4" "2) KDE Plasma" "3) LXQt" "4) MATE" "5) LXDE" "6) GNOME" >&2
  while true; do
    read -r -p "Desktop selection › " raw
    raw="${raw//[[:space:]]/}"
    [[ -n "$raw" ]] || { warn "Select at least one desktop."; continue; }
    local -a entries
    IFS=',' read -r -a entries <<< "$raw"
    result=''
    local valid=1
    for item in "${entries[@]}"; do
      key="$(desktop_key "$item")" || { valid=0; break; }
      [[ ",$result," == *",$key,"* ]] || result="${result:+$result,}$key"
    done
    if (( valid )); then printf '%s' "$result"; return 0; fi
    warn "Invalid selection. Use numbers 1 to 6, separated by commas."
  done
}
desktop_menu() {
  local selected
  selected="$(choose "Select the default desktop environment:" "XFCE4" "KDE Plasma" "LXQt" "MATE" "LXDE" "GNOME")"
  case "$selected" in
    "XFCE4") REDMUX_DESKTOP=xfce;;
    "KDE Plasma") REDMUX_DESKTOP=kde;;
    "LXQt") REDMUX_DESKTOP=lxqt;;
    "MATE") REDMUX_DESKTOP=mate;;
    "LXDE") REDMUX_DESKTOP=lxde;;
    "GNOME") REDMUX_DESKTOP=gnome;;
  esac
  if [[ ",$REDMUX_DESKTOPS," != *",$REDMUX_DESKTOP,"* ]]; then
    REDMUX_DESKTOPS="${REDMUX_DESKTOPS:+$REDMUX_DESKTOPS,}$REDMUX_DESKTOP"
  fi
  save_config
  info "Default desktop saved: $REDMUX_DESKTOP"
}
desktop_packages_for() {
  case "$1" in
    xfce) printf '%s\n' xfce4 xfce4-goodies xfce4-terminal thunar thunar-archive-plugin;;
    kde) printf '%s\n' kde-plasma-desktop konsole dolphin;;
    lxqt) printf '%s\n' lxqt qterminal pcmanfm-qt;;
    mate) printf '%s\n' mate-desktop-environment mate-terminal caja;;
    lxde) printf '%s\n' lxde lxterminal pcmanfm;;
    gnome) printf '%s\n' gnome-session gnome-shell gnome-terminal nautilus;;
    *) return 1;;
  esac
}
desktop_packages() {
  local desktop
  for desktop in ${REDMUX_DESKTOPS//,/ }; do desktop_packages_for "$desktop"; done
  printf '%s\n' dbus-x11 x11-xserver-utils fonts-dejavu fonts-noto xauth sudo wget curl ca-certificates nano vim less htop
}
desktop_command() {
  case "$1" in
    xfce) echo "dbus-launch --exit-with-session startxfce4";;
    kde) echo "dbus-launch --exit-with-session startplasma-x11";;
    lxqt) echo "dbus-launch --exit-with-session startlxqt";;
    mate) echo "dbus-launch --exit-with-session mate-session";;
    lxde) echo "dbus-launch --exit-with-session startlxde";;
    gnome) echo "dbus-run-session -- gnome-session";;
    *) return 1;;
  esac
}
desktop_installed() {
  local desktop="$1" package
  case "$desktop" in
    xfce) package=xfce4-session;;
    kde) package=plasma-workspace;;
    lxqt) package=lxqt-session;;
    mate) package=mate-session-manager;;
    lxde) package=lxsession;;
    gnome) package=gnome-session;;
    *) return 1;;
  esac
  proot-distro login --shared-tmp "$REDMUX_DISTRO" -- /usr/bin/dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'
}
