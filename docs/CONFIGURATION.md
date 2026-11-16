# Configuration Reference

REDMUX stores per-user settings in `~/.config/redmux/redmux.conf`.

## Settings

| Name | Default | Description |
| --- | --- | --- |
| `REDMUX_DISTRO` | `debian` | Default PRoot-Distro alias |
| `REDMUX_DESKTOP` | `xfce` | Default desktop key |
| `REDMUX_DESKTOPS` | `xfce` | Comma-separated desktop keys |
| `REDMUX_DISPLAY` | `:1` | X11 display used for the desktop session |
| `REDMUX_RESOLUTION` | empty | Reserved optional resolution value |

## Supported desktop keys

`xfce`, `kde`, `lxqt`, `mate`, `lxde`, and `gnome`.

## Editing settings

Run `redmux config` to change settings through the supported interface. If editing the file manually, use valid shell assignment syntax and quote string values. Invalid shell syntax can prevent REDMUX from loading its configuration.

## State and logs

- Installer state: `~/.local/share/redmux/install.state`
- Log file: `~/.local/state/redmux/redmux.log`

The installer state tracks the selected distribution, desktop list, and completed stages. It is used to resume a matching installation. Do not edit it while an installation is running.
