#!/data/data/com.termux/files/usr/bin/bash
uninstall_menu() {
  echo "REDMUX UNINSTALL MANAGER"
  echo "1) Remove REDMUX Only"
  echo "2) Full Clean Uninstall (remove selected Linux distributions)"
  echo "0) Cancel"
  read -r -p "Selection: " choice
  case "$choice" in
    1) uninstall_redmux_only;;
    2) uninstall_full;;
    0) return;;
    *) warn "Invalid selection";;
  esac
}
uninstall_redmux_only() {
  echo "This removes the REDMUX command and REDMUX configuration only."
  confirm "Continue?" || return
  session_stop || true
  rm -f "$PREFIX/bin/redmux"
  rm -rf "$PREFIX/share/redmux"
  rm -rf "$REDMUX_CONFIG_DIR" "$REDMUX_DATA_DIR" "$REDMUX_LOG_DIR"
  echo "REDMUX installation has been removed. The source repository was not touched."
}
uninstall_full() {
  echo "PERINGATAN: Full Clean Uninstall mengremove Linux distribution filesystems."
  echo "The REDMUX source repository will not be touched."
  local -a installed=()
  for d in debian ubuntu kali; do
    if distro_installed "$d"; then installed+=("$d"); fi
  done
  if (( ${#installed[@]} == 0 )); then
    warn "No REDMUX-supported Linux distributions were detected."
    if confirm "Remove only the REDMUX installation?"; then uninstall_redmux_only; fi
    return
  fi
  echo "Installed distributions recognized by REDMUX:"
  printf '  - %s\n' "${installed[@]}"
  local choices=("${installed[@]}" "ALL (hapus semua distribusi di atas)" "Cancel")
  local selected
  selected="$(choose "Select removal target:" "${choices[@]}")"
  [[ "$selected" == "Cancel" ]] && return
  local -a targets=()
  if [[ "$selected" == "ALL (hapus semua distribusi di atas)" ]]; then
    targets=("${installed[@]}")
  else
    targets=("$selected")
  fi
  echo
  echo "Will be removed: ${targets[*]}"
  echo "All applications, packages, configuration, and data INSIDE those distributions will be permanently deleted."
  echo "The REDMUX repository folder will NOT be deleted."
  local expected="REMOVE ${targets[*]}" typed
  read -r -p "Type exactly '$expected' untuk melanjutkan: " typed
  [[ "$typed" == "$expected" ]] || { warn "Confirmation did not match. Cancelled."; return; }
  session_stop || true
  for d in "${targets[@]}"; do
    log "Removing distribution $d."
    proot-distro remove "$d" || warn "Failed to remove $d; periksa log dan coba lagi."
  done
  if confirm "Also remove the installed REDMUX program (the source repository remains safe)?"; then
    uninstall_redmux_only
  else
    info "Selected environments have been processed. REDMUX remains installed."
  fi
}
