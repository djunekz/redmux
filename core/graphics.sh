#!/data/data/com.termux/files/usr/bin/bash
graphics_find_turnip_icd() {
  local candidate
  for candidate in "${PREFIX:-/nonexistent}"/share/vulkan/icd.d/*freedreno*.json "${PREFIX:-/nonexistent}"/share/vulkan/icd.d/*turnip*.json; do
    [[ -f "$candidate" ]] && { printf '%s' "$candidate"; return 0; }
  done
  return 1
}
graphics_virgl_available() {
  command -v virgl_test_server >/dev/null 2>&1 || command -v virgl_test_server_android >/dev/null 2>&1
}
graphics_turnip_available() {
  graphics_find_turnip_icd >/dev/null 2>&1
}
graphics_mode_effective() {
  case "$REDMUX_GPU_MODE" in
    software) printf 'software';;
    virgl) graphics_virgl_available && printf 'virgl' || printf 'unavailable';;
    turnip) graphics_turnip_available && printf 'turnip' || printf 'unavailable';;
    auto)
      if graphics_virgl_available; then printf 'virgl'
      elif graphics_turnip_available; then printf 'turnip'
      else printf 'software'
      fi
      ;;
    *) printf 'software';;
  esac
}
graphics_start() {
  local mode helper pid_file="$REDMUX_DATA_DIR/graphics.pid" pid command_line
  mode="$(graphics_mode_effective)"
  REDMUX_GPU_RUNTIME="$mode"
  [[ "$mode" == virgl ]] || return 0
  if [[ -f "$pid_file" ]]; then
    pid="$(cat "$pid_file" 2>/dev/null || true)"
    if [[ "$pid" =~ ^[0-9]+$ ]] && kill -0 "$pid" 2>/dev/null; then
      command_line="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)"
      [[ "$command_line" == *virgl_test_server* ]] && return 0
    fi
    rm -f "$pid_file"
  fi
  if command -v virgl_test_server_android >/dev/null 2>&1; then helper="$(command -v virgl_test_server_android)"
  elif command -v virgl_test_server >/dev/null 2>&1; then helper="$(command -v virgl_test_server)"
  else return 1
  fi
  "$helper" >> "$LOG_FILE" 2>&1 &
  pid=$!
  umask 077
  printf '%s\n' "$pid" > "$pid_file"
  sleep 1
  if ! kill -0 "$pid" 2>/dev/null; then
    rm -f "$pid_file"
    warn "VirGL helper exited during startup; software rendering will be used."
    REDMUX_GPU_RUNTIME=software
    return 1
  fi
  log "Started the REDMUX-managed VirGL helper (PID $pid)."
}
graphics_stop() {
  local pid_file="$REDMUX_DATA_DIR/graphics.pid" pid command_line
  [[ -f "$pid_file" ]] || return 0
  pid="$(cat "$pid_file" 2>/dev/null || true)"
  if [[ "$pid" =~ ^[0-9]+$ ]] && (( pid > 1 )) && kill -0 "$pid" 2>/dev/null; then
    command_line="$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null || true)"
    if [[ "$command_line" == *virgl_test_server* ]]; then
      kill -TERM "$pid" 2>/dev/null || true
      log "Stopped the REDMUX-managed VirGL helper (PID $pid)."
    else
      warn "The saved graphics PID no longer belongs to a VirGL helper; it was not terminated."
    fi
  fi
  rm -f "$pid_file"
}
graphics_environment() {
  local mode icd
  mode="${REDMUX_GPU_RUNTIME:-$(graphics_mode_effective)}"
  case "$mode" in
    software) printf '%s' 'export LIBGL_ALWAYS_SOFTWARE=1; unset GALLIUM_DRIVER;';;
    virgl) printf '%s' 'unset LIBGL_ALWAYS_SOFTWARE; export GALLIUM_DRIVER=virpipe;';;
    turnip)
      icd="$(graphics_find_turnip_icd)"
      printf 'unset LIBGL_ALWAYS_SOFTWARE; export VK_ICD_FILENAMES=%q; export MESA_LOADER_DRIVER_OVERRIDE=zink;' "$icd"
      ;;
    *) printf '%s' 'export LIBGL_ALWAYS_SOFTWARE=1;';;
  esac
}
graphics_status() {
  local mode arch android icd
  mode="$(graphics_mode_effective)"
  arch="$(uname -m 2>/dev/null || printf unknown)"
  android="$(getprop ro.build.version.release 2>/dev/null || printf unknown)"
  printf 'Graphics profile : %s\n' "$REDMUX_GPU_MODE"
  printf 'Effective mode   : %s\n' "$mode"
  printf 'Architecture     : %s\n' "$arch"
  printf 'Android version  : %s\n' "$android"
  printf 'VirGL helper     : '
  graphics_virgl_available && printf 'available\n' || printf 'not detected\n'
  printf 'Turnip Vulkan ICD: '
  icd="$(graphics_find_turnip_icd 2>/dev/null || true)"
  [[ -n "$icd" ]] && printf '%s\n' "$icd" || printf 'not detected\n'
  if [[ "$mode" == unavailable ]]; then
    warn "The selected graphics backend is not detected. Choose auto or software, or install a compatible driver stack for this device."
  fi
  info "GPU acceleration depends on the Android GPU, Termux repositories, driver stack, and guest application. Detection does not guarantee accelerated rendering."
}
