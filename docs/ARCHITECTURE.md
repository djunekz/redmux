# Architecture

## Runtime layout

- `redmux` is the application entry point, setup routine, and command dispatcher.
- `core/utils.sh` loads validated configuration, creates state directories, provides logging and prompts, renders the terminal interface, and manages installer state.
- `core/distro.sh` handles distribution validation, selection, listing, and shell access.
- `core/desktop.sh` defines desktop names, package sets, launch commands, and package verification.
- `core/session.sh` starts, tracks, stops, and reports REDMUX-managed desktop sessions.
- `core/x11.sh` checks, starts, and stops the Termux-side X11 process managed by REDMUX.
- `modules/installer.sh` checks dependencies and storage, installs a distribution, prepares APT, installs desktop packages, and verifies the result.
- `modules/diagnostics.sh` reports required commands, storage, configuration paths, and installer state.
- `modules/configuration.sh` provides the interactive settings menu.
- `modules/uninstaller.sh` implements guarded application and distribution removal.
- `config/defaults.conf` records the default configuration values.
- `assets/banner.txt` supplies the terminal wordmark. `assets/logo.svg` and `assets/menu.svg` are repository artwork.
- `docs/` contains user and developer documentation.

## Startup flow

1. Resolve the source checkout or installed application directory through `REDMUX_HOME`.
2. Load validated configuration values without executing the configuration file.
3. Load core services and feature modules.
4. Parse the command and arguments.
5. Dispatch to the requested workflow.

`redmux setup` copies `redmux`, `core/`, `modules/`, `config/`, and `assets/banner.txt` to `$PREFIX/share/redmux`, then creates the launcher in `$PREFIX/bin`. README artwork and documentation remain in the source repository.

## Dashboard rendering

The dashboard uses a single-column layout and fixed-width ASCII borders. Its width is based on the terminal size and is bounded to avoid excessively wide output. The large terminal banner is shown only when there is enough horizontal space; compact terminals receive a short text heading. `assets/menu.svg` is a README preview, not the live dashboard renderer.

## Configuration and state

Configuration is read from `~/.config/redmux/redmux.conf`. Only known keys and validated values are accepted. The installer stores the selected distribution, desktop set, and completed stage identifiers in `~/.local/share/redmux/install.state`. State is reused only when the new selection matches the saved selection.

## Session lifecycle

REDMUX records the process ID for the desktop session it starts. When `setsid` is available, the session runs in a separate process group; otherwise, only the recorded process can be signalled. The X11 PID file is created only when REDMUX starts the X11 command. Independently started X11 servers are not terminated by REDMUX.

## Execution model

REDMUX runs in Termux. Linux commands are invoked through `proot-distro login`; package installation occurs inside the selected distribution using APT. Desktop sessions are displayed through Termux:X11. PRoot does not provide a conventional Linux kernel, init system, or complete systemd/logind environment.

## Safety boundaries

- Removing a Linux distribution is destructive and requires explicit typed confirmation.
- Removing the installed REDMUX copy must not remove the source checkout.
- REDMUX stops only processes for which it has recorded process IDs; it does not kill unrelated desktop processes by name.
- The Android Termux:X11 application is installed separately from its Termux-side command-line package.
- User configuration, installer state, session records, and logs are stored under the Termux home directory.
