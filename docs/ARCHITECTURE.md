# Architecture

## Runtime layout

- `redmux` is the application entry point, setup routine, and command dispatcher.
- `core/utils.sh` provides configuration loading, logging, terminal styling, prompts, dashboard rendering, and installer-state helpers.
- `core/distro.sh` handles distribution selection, detection, listing, and shell access.
- `core/desktop.sh` defines desktop names, package sets, launch commands, and installation checks.
- `core/session.sh` manages desktop and X11 session operations.
- `core/x11.sh` detects and starts/stops Termux:X11 helpers.
- `modules/installer.sh` performs dependency checks, root filesystem installation, package setup, desktop installation, and verification.
- `modules/diagnostics.sh` reports environment and installation state.
- `modules/configuration.sh` manages user configuration.
- `modules/uninstaller.sh` implements guarded removal workflows.
- `config/defaults.conf` documents default settings.
- `assets/banner.txt` supplies the terminal wordmark. `assets/menu.svg` is a repository-only README illustration.
- `docs/` contains user and developer documentation.

## Startup flow

1. Resolve the source or installed application directory through `REDMUX_HOME`.
2. Load core services and feature modules.
3. Parse the command and arguments.
4. Dispatch to the matching workflow.

`redmux setup` copies only runtime files (`redmux`, `core/`, `modules/`, `config/`, and `assets/banner.txt`) into `$PREFIX/share/redmux`, then creates the launcher in `$PREFIX/bin`. Documentation images such as `assets/menu.svg` remain in the source repository.

## Dashboard rendering

The dashboard and installation summary panels are drawn with a responsive single-column layout, fixed-width ASCII borders, and optional ANSI colors. ASCII border characters avoid ambiguous display widths from Unicode box-drawing glyphs across Android terminal fonts. `assets/menu.svg` is embedded in README.md as a visual preview and is not part of the device installation. `assets/banner.txt` provides the terminal wordmark.

## Installation state

The installer stores the selected distribution, desktop set, and completed stage identifiers in `~/.local/share/redmux/install.state`. State is reusable only when the new selection matches the saved selection. A stage is marked complete only after its command and verification succeed.

## Execution model

REDMUX runs in Termux. Linux commands are invoked through `proot-distro login`; package installation occurs inside the selected distribution using APT. Desktop sessions are started through Termux:X11. PRoot does not provide a conventional kernel, init system, or complete systemd/logind environment.

## Safety boundaries

- Distribution removal is destructive and requires explicit typed confirmation.
- Removing the installed REDMUX copy must not remove the user's source checkout.
- The Android Termux:X11 application is outside the scope of Termux package installation.
- User configuration and state are stored under the user's Termux home directory.
