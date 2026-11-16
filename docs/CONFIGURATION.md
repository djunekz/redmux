# Configuration Reference

REDMUX stores user settings in `~/.config/redmux/redmux.conf`. Use `redmux config` to edit supported values.

## Settings

| Name | Default | Accepted values | Description |
| --- | --- | --- | --- |
| `REDMUX_DISTRO` | `debian` | `debian`, `ubuntu`, `kali` | Default PRoot-Distro alias |
| `REDMUX_DESKTOP` | `xfce` | `xfce`, `kde`, `lxqt`, `mate`, `lxde`, `gnome` | Default desktop key |
| `REDMUX_DESKTOPS` | `xfce` | Comma-separated desktop keys | Desktop environments selected for installation |
| `REDMUX_DISPLAY` | `:1` | `:0`, `:1`, `:2`, and other numeric displays | Termux:X11 display identifier |
| `REDMUX_RESOLUTION` | Empty | Empty or `WIDTHxHEIGHT` | Reserved value; not currently applied to the session |

## Editing settings

Run:

```bash
redmux config
```

The configuration reader accepts only the recognized keys and validates each value. It does not execute the configuration file as shell code. Unknown keys and invalid values are ignored. If editing manually, keep one `KEY=value` assignment per line and use only values from the accepted-value column.

## State and logs

| Path | Purpose |
| --- | --- |
| `~/.local/share/redmux/install.state` | Tracks completed installer stages for a matching selection |
| `~/.local/share/redmux/session.pid` | PID of the active REDMUX-managed desktop session |
| `~/.local/share/redmux/session.group` | Records whether the session uses a separate process group |
| `~/.local/share/redmux/x11.pid` | PID of a Termux:X11 process started by REDMUX |
| `~/.local/state/redmux/redmux.log` | Timestamped activity log |

Do not edit installer state or PID files while REDMUX is running. Stale PID files are checked before they are used.
