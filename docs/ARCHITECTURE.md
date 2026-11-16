# Architecture

## Runtime layout

- `redmux` — command dispatcher and application entry point.
- `core/utils.sh` — configuration, logging, terminal UI, prompts, and resumable state helpers.
- `core/distro.sh` — distribution selection, detection, listing, and shell access.
- `core/desktop.sh` — desktop metadata, package lists, session commands, and package verification.
- `core/session.sh` — desktop and X11 lifecycle operations.
- `core/x11.sh` — Termux:X11 CLI detection and startup helpers.
- `modules/installer.sh` — preflight, root filesystem installation, APT preparation, desktop installation, verification, and X11 preparation.
- `modules/diagnostics.sh` — environment and state diagnostics.
- `modules/configuration.sh` — interactive configuration.
- `modules/uninstaller.sh` — guarded removal workflows.
- `config/defaults.conf` — default configuration values.
- `assets/` — terminal banner and SVG artwork.

## Installation state

The installer stores the selected distribution, desktop set, and completed stage identifiers in `~/.local/share/redmux/install.state`. The state is reusable only when the new selection matches the saved selection. A stage must be marked complete only after its command and verification succeed.

## Execution model

REDMUX runs in Termux. Linux commands are invoked through `proot-distro login`; package installation occurs inside the selected distribution using APT. Desktop sessions are started through Termux:X11. PRoot does not provide a conventional kernel, init system, or complete systemd/logind environment.

## Safety boundaries

- Distribution removal is destructive and requires explicit typed confirmation.
- Removing the installed REDMUX copy must not remove the user's source checkout.
- The Android Termux:X11 application is outside the scope of Termux package installation.
- User configuration and state are stored under the user's Termux home directory.
