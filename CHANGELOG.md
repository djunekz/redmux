# Changelog

All notable project changes are recorded here. This file follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and version numbers follow [Semantic Versioning](https://semver.org/).

## [Unreleased]

---

## [1.0.0] - 2026-11-18

### Added

- Interactive REDMUX dashboard and direct command interface.
- Guided Debian, Ubuntu, and Kali Linux installation through PRoot-Distro.
- Multi-selection for XFCE4, KDE Plasma, LXQt, MATE, LXDE, and GNOME.
- Resumable installation state for matching distribution and desktop selections.
- Termux:X11 preparation and desktop start/stop operations.
- Configuration, diagnostics, status, environment listing, logs, and uninstall workflows.
- Cyan and blue terminal styling with a plain-text fallback.
- Project logo, README dashboard artwork, and terminal banner.
- GitHub issue and pull-request templates.
- Expanded project, user, and contributor documentation.
- Added process ID tracking for REDMUX-managed desktop and Termux:X11 sessions.
- Added configuration value validation and safe parsing of the user configuration file.
- Added regression tests for safe configuration loading, the setup installation boundary, compact terminal widths, and session-process safety.
- Added a quality-check guide for repeatable static and device validation.
- Expanded dashboard layout regression coverage for narrow terminal widths.
- Added Openbox, i3, Cinnamon, dwm, bspwm, Awesome, Fluxbox, IceWM, and Window Maker as desktop and window-manager choices.
- Added guest APT package search, install, remove, and list operations.
- Added curated theme and icon package installation.
- Added optional Wine and Winetricks installation and executable launch commands.
- Added Termux:API CLI setup guidance and installation.
- Added X11 legacy drawing and debug logging options, plus `--nogpu` and desktop startup overrides.
- Added GUI session shortcuts for Termux:X11 and VNC.
- Added safe configuration import/export/reset workflows.
- Added optional Termux:Boot autostart entry management.
- Added graphics capability detection and selectable auto, software, VirGL, and Turnip rendering profiles.
- Added optional TigerVNC installation and lifecycle commands with localhost-only server binding.
- Added configurable X11 framebuffer resolution, font DPI, VNC display, VNC resolution, and VNC color depth.
- Added PulseAudio startup when the Termux-side PulseAudio command is available.
- Added graphics capability reporting to diagnostics and session status.
- Added categorized CLI control-center navigation for installation, sessions, environments, display, graphics, software, personalization, and system management.
- Added dedicated interactive menus for desktop sessions, Termux:X11, VNC, graphics profiles, Linux software, and system tools.
- Added a live dashboard summary for the selected distribution, desktop, display, and effective graphics profile.
- Added interactive access to application search/install/remove/list, themes, Wine, Termux:API, VNC, and autostart workflows.
- Added command, configuration, architecture, and README documentation for the new capabilities.

### Changed

- Reorganized dashboard hierarchy and aligned menu entries for improved readability.
- Added consistent two-digit menu choices and clearer exit behavior.
- Expanded README with setup, requirements, commands, configuration, paths, and limitations.
- Rebuilt the dashboard and installation summary panels with fixed-width ASCII borders, responsive labels, and a single-column layout to prevent diagonal-looking edges, wrapped text, and misaligned frames.
- Removed the menu SVG from the device installation flow; `assets/menu.svg` is now a README/GitHub preview only.
- Simplified setup to install runtime files and the terminal text banner only.
- Reworked `assets/menu.svg` so the README preview matches the complete single-column dashboard and updated the documentation to distinguish the preview from the live terminal interface.
- Reworked dashboard, section, and stage labels so long text does not overflow narrow terminals.
- Reduced the minimum detected terminal width and adjusted completion text for compact displays.
- Replaced broad desktop-process name matching with targeted REDMUX-managed session shutdown.
- Changed Termux:X11 package installation to require user confirmation.
- Standardized user-facing shell messages and documentation in English.
- Rewrote README.md and aligned the command, configuration, architecture, installation, testing, and troubleshooting guides with the current implementation.
- Updated project structure and desktop documentation.
- Extended the validated configuration reader and atomic configuration writer for graphics, DPI, VNC, and X11 settings.
- Validated environment-provided configuration values before using them in generated guest commands.
- Applied configured X11 resolution and font DPI during desktop startup when the required guest utilities are available.
- Expanded desktop package mapping and launch handling for all added desktop environments and window managers.
- Kept VNC as an optional independent display path so existing Termux:X11 workflows remain unchanged.
- Redesigned the terminal dashboard as a categorized control center while preserving REDMUX's cyan-blue visual identity and compact single-column layout.
- Added nested menus to keep advanced operations discoverable without crowding the main dashboard.
- Updated CLI labels and navigation for narrow Android terminal screens and consistent two-digit selections.
- Updated the displayed project version to `1.0.0`; all unreleased work remains grouped under the original `1.0.0` entry.

### Fixed

- Replaced the obsolete progress helper call with the current UI stage renderer.
- Prevented invalid desktop keys from reaching package verification with an unset package name.
- Prevented arbitrary shell commands in the user configuration file from being executed during startup.
- Validated display identifiers before saving configuration.
- Improved stale PID handling so REDMUX does not signal an unrelated process when an X11 PID has been reused.
- Corrected outdated statements about SVG artwork being installed on the device.
- Replaced the previously reserved resolution setting with a best-effort X11 framebuffer application.
- Improved startup audio behavior by attempting to start PulseAudio before launching a desktop session.
- Aligned main-dashboard menu numbers with their corresponding actions and submenu destinations.
- Updated help output and version fallbacks to report the unreleased `1.0.0` development version consistently.

### Validation

- Shell syntax checks pass for the entry point, core scripts, modules, and tests.
- Dashboard layout tests cover 24, 28, 32, 36, 40, 64, and 80 columns.
- Markdown relative links, issue-template YAML, and SVG XML are included in the release validation checklist.
- Physical Android, Termux, PRoot-Distro, APT, and Termux:X11 integration still requires device testing.
- Shell syntax, configuration parsing, graphics profile selection, desktop mapping, VNC command dispatch, and regression tests are checked in the release validation pass.
- Real-device GPU acceleration, Android lifecycle behavior, Termux:X11 rendering, VNC connectivity, and desktop compatibility still require testing on target devices.
- Interactive CLI layout and menu navigation are covered by automated terminal-width and regression checks.

### Planned

- Expand automated checks and real-device compatibility coverage.
- Improve desktop session lifecycle reporting and add broader device integration coverage.
- Add additional distribution and desktop compatibility notes as they are verified.

### Documentation

- Added command and configuration references.
- Added Termux:X11 setup guide and project structure overview.
- Added release checklist and expanded troubleshooting guidance.

### Notes

- `assets/logo.svg` and `assets/menu.svg` are repository artwork. `redmux setup` copies only runtime files and `assets/banner.txt`.
- Android, PRoot-Distro, package, and desktop compatibility must be tested on a real device.
