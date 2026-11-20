#!/data/data/com.termux/files/usr/bin/bash
desktop_name() {
  case "$1" in
    xfce) printf 'XFCE4';;
    kde) printf 'KDE Plasma';;
    lxqt) printf 'LXQt';;
    mate) printf 'MATE';;
    lxde) printf 'LXDE';;
    gnome) printf 'GNOME';;
    openbox) printf 'Openbox';;
    i3) printf 'i3 Window Manager';;
    cinnamon) printf 'Cinnamon';;
    dwm) printf 'dwm';;
    bspwm) printf 'bspwm';;
    awesome) printf 'Awesome';;
    fluxbox) printf 'Fluxbox';;
    icewm) printf 'IceWM';;
    wmaker) printf 'Window Maker';;
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
    7|openbox|Openbox) printf 'openbox';;
    8|i3) printf 'i3';;
    9|cinnamon|Cinnamon) printf 'cinnamon';;
    10|dwm) printf 'dwm';;
    11|bspwm) printf 'bspwm';;
    12|awesome|Awesome) printf 'awesome';;
    13|fluxbox|Fluxbox) printf 'fluxbox';;
    14|icewm|IceWM) printf 'icewm';;
    15|wmaker|'Window Maker') printf 'wmaker';;
    *) return 1;;
  esac
}
desktop_select_many() {
  local raw item key result='' index
  printf '%s\n' "Choose your desktop environment(s)." "Select multiple options with commas, for example: 1,3,4" "1) XFCE4" "2) KDE Plasma" "3) LXQt" "4) MATE" "5) LXDE" "6) GNOME" "7) Openbox" "8) i3 Window Manager" "9) Cinnamon" "10) dwm" "11) bspwm" "12) Awesome" "13) Fluxbox" "14) IceWM" "15) Window Maker" >&2
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
    warn "Invalid selection. Use numbers 1 to 15, separated by commas."
  done
}
desktop_menu() {
  local selected
  selected="$(choose "Select the default desktop environment:" "XFCE4" "KDE Plasma" "LXQt" "MATE" "LXDE" "GNOME" "Openbox" "i3 Window Manager" "Cinnamon" "dwm" "bspwm" "Awesome" "Fluxbox" "IceWM" "Window Maker")"
  case "$selected" in
    "XFCE4") REDMUX_DESKTOP=xfce;;
    "KDE Plasma") REDMUX_DESKTOP=kde;;
    "LXQt") REDMUX_DESKTOP=lxqt;;
    "MATE") REDMUX_DESKTOP=mate;;
    "LXDE") REDMUX_DESKTOP=lxde;;
    "GNOME") REDMUX_DESKTOP=gnome;;
    "Openbox") REDMUX_DESKTOP=openbox;;
    "i3 Window Manager") REDMUX_DESKTOP=i3;;
    "Cinnamon") REDMUX_DESKTOP=cinnamon;;
    "dwm") REDMUX_DESKTOP=dwm;;
    "bspwm") REDMUX_DESKTOP=bspwm;;
    "Awesome") REDMUX_DESKTOP=awesome;;
    "Fluxbox") REDMUX_DESKTOP=fluxbox;;
    "IceWM") REDMUX_DESKTOP=icewm;;
    "Window Maker") REDMUX_DESKTOP=wmaker;;
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
    openbox) printf '%s\n' openbox obconf tint2 lxterminal pcmanfm;;
    i3) printf '%s\n' i3-wm i3status i3lock dmenu xterm;;
    cinnamon) printf '%s\n' cinnamon-desktop-environment cinnamon-session nemo gnome-terminal;;
    dwm) printf '%s\n' dwm suckless-tools xterm;;
    bspwm) printf '%s\n' bspwm sxhkd rofi xterm;;
    awesome) printf '%s\n' awesome awesome-extra xterm;;
    fluxbox) printf '%s\n' fluxbox fbterm xterm;;
    icewm) printf '%s\n' icewm icewm-themes xterm;;
    wmaker) printf '%s\n' wmaker wmaker-data xterm;;
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
    openbox) echo "dbus-launch --exit-with-session openbox-session";;
    i3) echo "dbus-launch --exit-with-session i3";;
    cinnamon) echo "dbus-launch --exit-with-session cinnamon-session";;
    dwm) echo "dbus-launch --exit-with-session dwm";;
    bspwm) echo "dbus-launch --exit-with-session sh -lc 'sxhkd & exec bspwm'";;
    awesome) echo "dbus-launch --exit-with-session awesome";;
    fluxbox) echo "dbus-launch --exit-with-session startfluxbox";;
    icewm) echo "dbus-launch --exit-with-session icewm-session";;
    wmaker) echo "dbus-launch --exit-with-session wmaker";;
    *) return 1;;
  esac
}
desktop_installed() {
  local desktop="$1" distro="${2:-$REDMUX_DISTRO}" package
  case "$desktop" in
    xfce) package=xfce4-session;;
    kde) package=plasma-workspace;;
    lxqt) package=lxqt-session;;
    mate) package=mate-session-manager;;
    lxde) package=lxsession;;
    gnome) package=gnome-session;;
    openbox) package=openbox;;
    i3) package=i3-wm;;
    cinnamon) package=cinnamon-session;;
    dwm) package=dwm;;
    bspwm) package=bspwm;;
    awesome) package=awesome;;
    fluxbox) package=fluxbox;;
    icewm) package=icewm;;
    wmaker) package=wmaker;;
    *) return 1;;
  esac
  proot-distro login --shared-tmp "$distro" -- /usr/bin/dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q 'install ok installed'
}
