# REDMUX

<p align="center">
  <img src="assets/logo.svg" alt="REDMUX logo" width="180">
</p>

<h1 align="center">REDMUX</h1>
<p align="center"><strong>Termux Linux Desktop Manager</strong></p>
<p align="center">Build, manage, and launch Linux desktop environments on Android with Termux and PRoot-Distro.</p>

<p align="center">
  <img alt="Version" src="https://img.shields.io/badge/version-1.0.0-20c997?style=for-the-badge">
  <img alt="Platform" src="https://img.shields.io/badge/platform-Termux-111827?style=for-the-badge">
  <img alt="License" src="https://img.shields.io/badge/license-MIT-64748b?style=for-the-badge">
</p>

> **Release status:** REDMUX remains at **1.0.0**. This project is intended for testing; compatibility depends on the Android device, Termux build, distribution repositories, and desktop package versions.

## Project artwork

- `assets/logo.svg` — REDMUX terminal emblem.
- `assets/menu.svg` — dashboard/menu concept artwork.
- `assets/banner.txt` — terminal banner displayed by the CLI.

## Overview

REDMUX is a command-line manager for installing and operating Linux distributions under [PRoot-Distro](https://github.com/termux/proot-distro), then launching supported desktop environments through [Termux:X11](https://github.com/termux/termux-x11). It provides a guided installer, multi-desktop selection, resumable installation stages, session controls, diagnostics, logs, and uninstall options.

REDMUX does not virtualize hardware or provide a full systemd boot environment. PRoot is a userspace compatibility layer, so some services and desktop features may behave differently from a conventional Linux installation.

## Features

- Guided selection of Debian, Ubuntu, or Kali Linux.
- Install one or multiple desktop environments in one setup: XFCE4, KDE Plasma, LXQt, MATE, LXDE, and GNOME.
- Select the default desktop and choose an installed desktop at launch when multiple environments are configured.
- Check and offer to install missing Termux dependencies, including PRoot-Distro.
- Install the Linux root filesystem through PRoot-Distro.
- Prepare APT, repair interrupted package configuration, and install missing desktop packages.
- Save installation progress and resume matching unfinished installations.
- Prepare the Termux:X11 command-line package when needed.
- Start, stop, and restart desktop sessions.
- Open a Linux shell, inspect environments, view status, diagnostics, and logs.
- Remove the REDMUX installation separately from Linux distributions.
- Keep the cloned source repository untouched during REDMUX uninstall operations.

## Supported environments

| Component | Supported choices | Notes |
|---|---|---|
| Linux distribution | Debian, Ubuntu, Kali Linux | Installed using PRoot-Distro aliases |
| Desktop | XFCE4, KDE Plasma, LXQt, MATE, LXDE, GNOME | Package availability varies by distribution |
| Display | Termux:X11 | Android companion app is installed separately |
| Architecture | Device/Termux supported architectures | Package availability is controlled by upstream repositories |

XFCE4 is a sensible first desktop to try on devices with limited memory. KDE Plasma and GNOME can require substantially more storage and memory. This is guidance, not a guaranteed performance ranking for every device.

## Requirements

- Android device with a working Termux installation.
- Termux packages and plugins from compatible sources. Avoid mixing Termux builds from unrelated distribution channels.
- Working internet connection during package and root filesystem downloads.
- Sufficient free storage. A desktop installation can consume several gigabytes; the exact amount depends on the selected distribution and desktop packages.
- Termux:X11 Android application for graphical sessions.

### Termux:X11 components

Termux:X11 has two parts:

1. The Termux-side command-line package, which REDMUX can check and prepare.
2. The Android Termux:X11 application, which must be installed separately from its official project releases.

Installing the CLI package does not install the Android application. See the [Termux:X11 project](https://github.com/termux/termux-x11).

## Installation

Clone the repository:

```bash
pkg update
pkg install git
git clone https://github.com/djunekz/redmux.git
cd redmux
chmod +x redmux
./redmux setup
```

The `setup` command copies REDMUX into Termux's shared application prefix and installs a `redmux` launcher in `$PREFIX/bin`. The cloned repository remains available for editing and updates.

To run directly from the cloned source without installing the launcher:

```bash
chmod +x redmux
./redmux
```

## Quick start

```bash
redmux install
redmux start
```

Open a shell inside the configured Linux distribution:

```bash
redmux shell
```

If more than one desktop environment was selected and installed, REDMUX asks which one to launch.

## Command reference

| Command | Description |
|---|---|
| `redmux` | Open the interactive dashboard |
| `redmux install` | Install or resume a Linux desktop setup |
| `redmux start [distro]` | Launch the configured desktop |
| `redmux stop` | Stop the desktop session started by REDMUX |
| `redmux restart` | Stop and start the desktop session |
| `redmux shell [distro]` | Open a shell in a supported distribution |
| `redmux environments` | Display PRoot-Distro environment information |
| `redmux desktop` | Choose the default desktop environment |
| `redmux status` | Show configured distribution, desktop, and X11 status |
| `redmux config` | Open configuration options |
| `redmux logs` | Display recent REDMUX logs |
| `redmux diagnose` | Check dependencies and installation state |
| `redmux uninstall` | Open the uninstall manager |
| `redmux setup` | Install or refresh the Termux launcher |
| `redmux version` | Print the current version |
| `redmux help` | Show command help |

## Installation workflow

The installer follows these major stages:

1. **Preflight** — verify Termux commands, offer to install PRoot-Distro if missing, check required packages, and inspect available storage.
2. **Configuration** — select a Linux distribution and one or more desktop environments.
3. **Root filesystem** — install the selected distribution using PRoot-Distro, or reuse an existing installation.
4. **APT preparation** — update package indexes and repair pending package configuration.
5. **Desktop packages** — install the selected desktop packages and shared utilities.
6. **Verification** — verify that the selected desktop session packages are installed.
7. **X11 preparation** — check and prepare the Termux-side Termux:X11 command.

The progress indicator represents installer stages. Download progress for root filesystems is provided by PRoot-Distro, while APT reports package download and installation activity.

## Resuming an interrupted installation

If an installation is interrupted, run:

```bash
redmux install
```

When the saved distribution and desktop selection match, REDMUX resumes from the last completed stage. If you choose a different configuration, REDMUX asks whether to replace the previous installation state.

APT may reuse packages already present in its local cache. A failed stage is not considered complete; inspect the error output and logs before retrying.

## Configuration and data locations

| Path | Purpose |
|---|---|
| `~/.config/redmux/redmux.conf` | User configuration |
| `~/.local/share/redmux/install.state` | Temporary resumable installation state |
| `~/.local/share/redmux/` | REDMUX runtime state, including X11 PID data |
| `~/.local/state/redmux/redmux.log` | REDMUX log file |
| `$PREFIX/share/redmux/` | Installed REDMUX program files after `redmux setup` |
| `$PREFIX/bin/redmux` | Installed command launcher |

Configuration is managed through `redmux config`. Avoid editing the configuration while an installation is running.

## Uninstall behavior

REDMUX provides separate removal paths:

- **Remove REDMUX only:** removes the installed launcher, installed program copy, and REDMUX user configuration/state/log data. It does not remove the cloned source repository.
- **Full clean uninstall:** asks for an explicit typed confirmation before removing the selected PRoot-Distro environment(s). The source repository is not deleted. You can optionally remove the installed REDMUX program afterward.

Removing a Linux distribution permanently deletes the applications, packages, and user data stored inside that distribution. Back up important files first.

## Troubleshooting

### `proot-distro` is missing

Run `redmux install` and accept the prompt to install PRoot-Distro. If package installation fails, check the Termux repository configuration and internet connection, then run `pkg update` and retry.

### Root filesystem download fails

Check connectivity, free storage, and whether the upstream registry is reachable. Retry `redmux install`; PRoot-Distro controls root filesystem downloads and retries.

### APT or desktop package installation fails

Read the last APT error in the terminal and inspect `redmux logs`. Common causes include interrupted package configuration, unavailable mirrors, insufficient storage, or packages that are not available for the selected distribution release. Resolve the reported issue and rerun `redmux install`.

### Desktop is installed but does not start

Confirm that the Android Termux:X11 app is installed and opened, then run `redmux diagnose`. Check `redmux logs` and verify that the selected desktop package is installed. Some desktop components expect systemd, logind, or services that are not fully available under PRoot.

### No graphical window appears

Check that the Termux:X11 Android app and Termux CLI package are compatible versions. Confirm that Android has not restricted background execution for Termux. Then run `redmux stop` and retry `redmux start`.

### Need to report a bug

Please include the output of `redmux version`, `redmux diagnose`, the relevant terminal error, Android version, device architecture, Termux source, and the distribution/desktop selection. Remove usernames, private paths, tokens, and other sensitive information before posting.

## Project documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Installation and testing](docs/INSTALLATION.md)
- [Troubleshooting guide](docs/TROUBLESHOOTING.md)
- [Security policy](SECURITY.md)
- [Contributing](CONTRIBUTING.md)
- [Support](SUPPORT.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)
- [Changelog](CHANGELOG.md)

## Contributing

Bug reports, compatibility notes, documentation improvements, and focused pull requests are welcome. Please read [CONTRIBUTING.md](CONTRIBUTING.md) before submitting changes. Keep the project version at `1.0.0` until an official release decision is made.

## Disclaimer

REDMUX is an independent community project and is not affiliated with or endorsed by the Termux, PRoot-Distro, Debian, Ubuntu, Kali Linux, or Termux:X11 maintainers. Linux distributions and desktop environments are provided by their respective upstream projects. Use at your own risk and keep backups of important data.

## License

REDMUX is released under the MIT License. See [LICENSE](LICENSE).
