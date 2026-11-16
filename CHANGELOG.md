# Changelog

All notable project changes are recorded here. This file follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and version numbers follow [Semantic Versioning](https://semver.org/).

## [Unreleased] - 2026-11-17

### Added

- Added process ID tracking for REDMUX-managed desktop and Termux:X11 sessions.
- Added configuration value validation and safe parsing of the user configuration file.
- Added regression tests for safe configuration loading, the setup installation boundary, compact terminal widths, and session-process safety.
- Added a quality-check guide for repeatable static and device validation.
- Expanded dashboard layout regression coverage for narrow terminal widths.

### Changed

- Reworked dashboard, section, and stage labels so long text does not overflow narrow terminals.
- Reduced the minimum detected terminal width and adjusted completion text for compact displays.
- Replaced broad desktop-process name matching with targeted REDMUX-managed session shutdown.
- Changed Termux:X11 package installation to require user confirmation.
- Standardized user-facing shell messages and documentation in English.
- Rewrote README.md and aligned the command, configuration, architecture, installation, testing, and troubleshooting guides with the current implementation.
- Updated project structure and desktop documentation.

### Fixed

- Replaced the obsolete progress helper call with the current UI stage renderer.
- Prevented invalid desktop keys from reaching package verification with an unset package name.
- Prevented arbitrary shell commands in the user configuration file from being executed during startup.
- Validated display identifiers before saving configuration.
- Improved stale PID handling so REDMUX does not signal an unrelated process when an X11 PID has been reused.
- Corrected outdated statements about SVG artwork being installed on the device.

### Validation

- Shell syntax checks pass for the entry point, core scripts, modules, and tests.
- Dashboard layout tests cover 24, 28, 32, 36, 40, 64, and 80 columns.
- Markdown relative links, issue-template YAML, and SVG XML are included in the release validation checklist.
- Physical Android, Termux, PRoot-Distro, APT, and Termux:X11 integration still requires device testing.

## [1.0.0] - 2026-11-16

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
- User and contributor documentation.

### Notes

- The release version is `1.0.0`.
- `assets/logo.svg` and `assets/menu.svg` are repository artwork. `redmux setup` copies only runtime files and `assets/banner.txt`.
- Android, PRoot-Distro, package, and desktop compatibility must be tested on a real device.
