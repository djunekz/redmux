<div align="center">
  <img src="assets/logo.svg" alt="REDMUX logo" width="280">
  <h1>REDMUX</h1>
  <p><strong>Termux Linux Desktop Manager</strong></p>
  <p>A cleaner way to build and manage a Linux desktop on Android.</p>
  <img src="assets/menu.svg" alt="REDMUX dashboard preview" width="100%">
  <p><strong>Version 1.0.0</strong> · Android · Termux · PRoot-Distro · Termux:X11</p>
</div>

REDMUX is a terminal-based manager for installing a Linux distribution in Termux, adding a desktop environment, and launching its graphical session through Termux:X11. It provides an interactive dashboard as well as direct commands for installation, sessions, configuration, diagnostics, logs, and removal.

> REDMUX does not provide a Linux kernel or a full virtual machine. Linux environments run through PRoot-Distro and inherit its compatibility limitations.

## Contents

- [Features](#features)
- [Preview and artwork](#preview-and-artwork)
- [Requirements](#requirements)
- [Installation](#installation)
- [First-time setup](#first-time-setup)
- [Commands](#commands)
- [Supported environments](#supported-environments)
- [Configuration](#configuration)
- [Files and data](#files-and-data)
- [Uninstall](#uninstall)
- [Troubleshooting](#troubleshooting)
- [Documentation](#documentation)
- [Development](#development)
- [Contributing](#contributing)
- [Disclaimer](#disclaimer)
- [License](#license)

## Features

- Interactive dashboard with a consistent cyan and blue terminal theme.
- Linux distribution setup using PRoot-Distro.
- Guided selection of one or more desktop environments.
- Desktop launch and stop commands using Termux:X11.
- Installation stages with resumable state for matching selections.
- Configuration management, environment listing, status checks, and diagnostics.
- Timestamped activity log and guarded uninstall workflow.
- Plain-text fallback when output is redirected or `NO_COLOR` is set.
- SVG logo and dashboard artwork included in the installed application directory.

## Preview and artwork

The preview above is the project illustration stored at `assets/menu.svg`. GitHub renders it directly from the repository. It is not copied by `redmux setup` and is not needed at runtime. The live dashboard is rendered separately by the shell interface; its single-column layout uses fixed-width ASCII borders so the frame stays aligned across terminal fonts and display widths.

| Asset | Purpose |
| --- | --- |
| `assets/logo.svg` | Project logo and brand mark |
| `assets/menu.svg` | README dashboard preview only; not installed on the device |
| `assets/banner.txt` | Text banner shown in the terminal |

## Requirements

- Android device supported by your Termux distribution.
- A current Termux installation from a supported source.
- Working network connection for package and root filesystem downloads.
- Sufficient free storage for the selected Linux distribution and desktop packages. Desktop installations can require several gigabytes.
- Termux:X11 Android application installed separately.
- Termux-side `termux-x11` command/package for graphical sessions.

REDMUX can install PRoot-Distro when it is missing. Package availability and desktop compatibility depend on the selected distribution release and device architecture.

## Installation

Install the project from its source directory:

```bash
pkg update && pkg upgrade
pkg install git
git clone https://github.com/djunekz/redmux.git
cd redmux
chmod +x redmux
./redmux setup
```

After setup, the `redmux` command is installed in `$PREFIX/bin` and the application files are copied to `$PREFIX/share/redmux`.

To run without installing the launcher, use:

```bash
bash redmux
```

## First-time setup

1. Open REDMUX with `redmux`.
2. Select **Install Linux + Desktop**.
3. Choose Debian, Ubuntu, or Kali Linux.
4. Choose one or more desktop environments when prompted.
5. Review the installation plan and allow the installation stages to finish.
6. Install and open the Android Termux:X11 application.
7. Start the desktop with `redmux start`.

Keep Termux open while package installation is running. Do not interrupt APT or dpkg while packages are being configured. If an installation is interrupted, run `redmux install` again; completed stages may be reused when the distribution and desktop selection match.

## Commands

| Command | Description |
| --- | --- |
| `redmux` or `redmux menu` | Open the interactive dashboard |
| `redmux setup` | Install/update the command launcher and application files |
| `redmux install` | Install or resume Linux and desktop setup |
| `redmux start [distro]` | Start the configured desktop session |
| `redmux stop` | Stop the active desktop session and the REDMUX-managed X11 process |
| `redmux restart` | Stop and start the desktop session |
| `redmux shell [distro]` | Open a shell inside a Linux distribution |
| `redmux environments` | List PRoot-Distro environments |
| `redmux desktop` | Select the default desktop environment |
| `redmux status` | Display configuration and session status |
| `redmux config` | Open configuration options |
| `redmux diagnose` | Check dependencies and installation state |
| `redmux logs` | Display recent REDMUX logs |
| `redmux uninstall` | Open the guarded removal workflow |
| `redmux version` | Print the installed version |
| `redmux help` | Display command help |

The dashboard accepts options `01` through `10`; enter `00` or `0` to exit. Single-digit choices are accepted for convenience.

## Supported environments

### Linux distributions

- Debian
- Ubuntu
- Kali Linux

### Desktop environments

- XFCE4
- KDE Plasma
- LXQt
- MATE
- LXDE
- GNOME

The package names and session commands are defined in `core/desktop.sh`. Not every desktop is equally suitable for PRoot or every device. XFCE4 is a practical lightweight starting point for many devices, but actual compatibility should be tested on the target device.

## Configuration

Use the interactive configuration screen:

```bash
redmux config
```

The default configuration file is:

```text
~/.config/redmux/redmux.conf
```

Available settings include:

| Variable | Default | Meaning |
| --- | --- | --- |
| `REDMUX_DISTRO` | `debian` | Default Linux distribution |
| `REDMUX_DESKTOP` | `xfce` | Default desktop environment |
| `REDMUX_DESKTOPS` | `xfce` | Comma-separated configured desktop environments |
| `REDMUX_DISPLAY` | `:1` | X11 display identifier |
| `REDMUX_RESOLUTION` | empty | Optional resolution setting |

Prefer `redmux config` so values are written in the expected format. Back up the configuration before manual edits.

## Files and data

| Path | Purpose |
| --- | --- |
| `~/.config/redmux/redmux.conf` | User configuration |
| `~/.local/share/redmux/install.state` | Resumable installer state |
| `~/.local/state/redmux/redmux.log` | Activity log |
| `$PREFIX/share/redmux/` | Runtime files (`redmux`, `core/`, `modules/`, `config/`, and terminal banner) |
| `$PREFIX/bin/redmux` | Command launcher |

The source checkout is separate from the installed copy. Removing the installed application does not delete the source checkout.

## Uninstall

The uninstall workflow distinguishes between removing REDMUX and removing Linux environments. Removing a distribution deletes its installed packages and user data inside that environment. Back up important files first and read each confirmation prompt carefully. Full environment removal requires explicit confirmation.

## Troubleshooting

Start by collecting the following information:

```bash
redmux version
redmux status
redmux diagnose
redmux logs
proot-distro list
```

Common issues and recovery steps are covered in [the troubleshooting guide](docs/TROUBLESHOOTING.md). Remove private paths, usernames, tokens, and other sensitive details before sharing diagnostic output.

## Documentation

- [Installation and testing](docs/INSTALLATION.md)
- [Architecture](docs/ARCHITECTURE.md)
- [Troubleshooting](docs/TROUBLESHOOTING.md)
- [Command reference](docs/COMMANDS.md)
- [Configuration reference](docs/CONFIGURATION.md)
- [Termux:X11 guide](docs/TERMUX-X11.md)
- [Testing guide](docs/TESTING.md)
- [Project structure](docs/PROJECT-STRUCTURE.md)
- [Release checklist](docs/RELEASE-CHECKLIST.md)
- [FAQ](FAQ.md)
- [Roadmap](ROADMAP.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
- [Security policy](SECURITY.md)
- [Support](SUPPORT.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

## Development

Run syntax checks before submitting changes:

```bash
bash -n redmux
for file in core/*.sh modules/*.sh tests/*.sh; do bash -n "$file" || exit 1; done
bash tests/test-ui.sh
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the contribution workflow. Syntax checks are not a substitute for testing package installation and desktop sessions on a real Android device.

## Contributing

Bug reports, device compatibility notes, documentation updates, and focused pull requests are welcome. Use the issue templates when reporting a bug or proposing a feature. Please include reproducible steps and relevant diagnostics, with private information removed.

## Disclaimer

REDMUX is an independent community project and is not affiliated with or endorsed by the Termux, PRoot-Distro, Debian, Ubuntu, Kali Linux, or Termux:X11 maintainers. Linux distributions, desktop environments, and supporting applications remain the property of their respective projects. Use at your own risk and keep backups of important data.

## License

REDMUX is released under the MIT License. See [LICENSE](LICENSE).
