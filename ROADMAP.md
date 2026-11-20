# Roadmap

This document records possible areas of improvement. Items are ideas, not delivery guarantees.

## Reliability

- Expand automated tests for state recovery, failed installer stages, and interrupted VNC startup.
- Validate package names and desktop launchers across supported distribution releases.
- Improve detection of partially installed or manually modified Linux environments.
- Add process-tree-aware session tracking without signalling unrelated processes.
- Add automated compatibility checks for graphics backend startup and fallback.

## Graphics and display

- Build a device-aware graphics driver installer after validating package sources and GPU/Android combinations.
- Verify VirGL, Turnip, Zink, Mesa, and software-rendering combinations on real Android devices.
- Add a tested device and GPU compatibility matrix.
- Measure rendering performance and expose renderer information from guest applications.
- Expand Termux:X11 and VNC resolution, DPI, and multi-display integration tests.

## User experience

- Add a graphical application catalog on top of the existing guest APT package manager.
- Add remote X11 display routing with explicit network and authentication guidance.
- Add optional chroot/container backends where the device is rooted and the environment is supported.
- Add an optional non-interactive configuration mode.
- Improve terminal capability detection for narrow screens and limited shells.
- Add clearer per-stage elapsed-time and failure summaries.
- Add optional desktop profiles for low-memory, balanced, and high-performance devices.

## Documentation and compatibility

- Maintain a tested Android, device architecture, distribution, and desktop compatibility matrix.
- Add reproducible real-device test procedures.
- Document known limitations for each desktop environment under PRoot.
- Keep the changelog synchronized with each implementation change.
- Evaluate additional package-manager backends only when their reliability and maintenance status are suitable; the current workflow remains APT-first.
