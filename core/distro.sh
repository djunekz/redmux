#!/data/data/com.termux/files/usr/bin/bash
distro_supported() { case "$1" in debian|ubuntu|kali) return 0;; *) return 1;; esac; }
distro_installed() {
  local alias="$1"
  command -v proot-distro >/dev/null 2>&1 || return 1
  proot-distro login --shared-tmp "$alias" -- /bin/true >/dev/null 2>&1
}
distro_select() {
  local selected
  selected="$(choose "Select a Linux distribution:" "Debian" "Ubuntu" "Kali Linux")"
  case "$selected" in Debian) REDMUX_DISTRO=debian;; Ubuntu) REDMUX_DISTRO=ubuntu;; "Kali Linux") REDMUX_DISTRO=kali;; esac
  save_config
}
distro_list() {
  command -v proot-distro >/dev/null || { echo "proot-distro is not installed."; return 1; }
  proot-distro list
}
distro_shell() {
  local d="${1:-$REDMUX_DISTRO}"
  if [[ -z "${1:-}" ]]; then d="$(choose "Select a distribution:" "debian" "ubuntu" "kali")"; fi
  distro_supported "$d" || die "Unsupported distribution: $d"
  distro_installed "$d" || die "$d is not installed. Run redmux install."
  proot-distro login --shared-tmp "$d"
}
