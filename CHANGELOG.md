# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to semantic versioning.

## [Unreleased]

---

## [1.0.0] - 2026-11-16

### Added
- Interactive terminal dashboard with a compact sectioned layout.
- Color-aware CLI presentation with automatic plain-text fallback when output is redirected or `NO_COLOR` is set.
- Guided Linux distribution and multi-desktop selection.
- Installation stage indicators and installation summary.
- Resumable installation state for matching distribution and desktop selections.
- Dependency preflight and guided PRoot-Distro installation when missing.
- Termux:X11 CLI preparation and session management.
- Diagnostics, configuration, logs, environment listing, and uninstall workflows.
- Project documentation, contribution guidance, security policy, support guide, and GitHub issue templates.
- SVG brand mark and dashboard menu artwork.

### Changed
- Reworked terminal banner, dashboard hierarchy, status symbols, progress display, and completion summary.
- Standardized primary user-facing CLI and project documentation in English.
- Expanded README with requirements, workflows, command reference, data locations, limitations, and troubleshooting.
- Clarified that the Android Termux:X11 app is installed separately from its Termux CLI package.
- Clarified that uninstall operations must not delete the user's cloned source repository.

### Notes
- REDMUX remains at version `1.0.0` until an official release is announced.
- Device-level Android/Termux runtime compatibility must be verified on real devices; shell syntax checks alone are not a full integration test.
