# Changelog

All notable project changes are recorded here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and version numbers follow Semantic Versioning.

## [Unreleased]

---

## [1.0.0] - 2026-11-16

### Added
- Interactive REDMUX dashboard and direct command interface.
- Guided Debian, Ubuntu, and Kali Linux installation through PRoot-Distro.
- Multi-selection for XFCE4, KDE Plasma, LXQt, MATE, LXDE, and GNOME.
- Resumable installation state for matching distribution and desktop selections.
- Termux:X11 session preparation and desktop start/stop operations.
- Configuration, diagnostics, status, environment listing, logs, and uninstall workflows.
- Cyan/blue terminal theme with a plain-text fallback.
- Project logo, dashboard SVG artwork, and terminal banner.
- GitHub issue and pull-request templates.
- Expanded project, user, and contributor documentation.

### Changed
- Reorganized dashboard hierarchy and aligned menu entries for improved readability.
- Added consistent two-digit menu choices and clearer exit behavior.
- Expanded README with setup, requirements, commands, configuration, paths, and limitations.
- Rebuilt the dashboard and installation summary panels with fixed-width ASCII borders, responsive labels, and a single-column layout to prevent diagonal-looking edges, wrapped text, and misaligned frames.
- Removed the menu SVG from the device installation flow; `assets/menu.svg` is now a README/GitHub preview only.
- Simplified setup to install runtime files and the terminal text banner only.
- Reworked `assets/menu.svg` so the README preview matches the complete single-column dashboard and updated the documentation to distinguish the preview from the live terminal interface.

### Planned
- Expand automated checks and real-device compatibility coverage.
- Improve desktop session lifecycle reporting.
- Add additional distribution and desktop compatibility notes as they are verified.

### Documentation
- Added command and configuration references.
- Added Termux:X11 setup guide and project structure overview.
- Added release checklist and expanded troubleshooting guidance.

### Notes
- The release version remains `1.0.0`.
- `assets/logo.svg` and `assets/menu.svg` are repository artwork. `redmux setup` copies only the terminal banner from `assets/`; the live UI is rendered by shell functions.
- Device-level Android, PRoot-Distro, package, and desktop compatibility requires real-device testing.
