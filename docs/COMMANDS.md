# Command Reference

REDMUX provides an interactive dashboard and direct command-line operations. Run commands from Termux after installing the launcher with `./redmux setup`, or run `bash redmux` from the source checkout.

## Syntax

```text
redmux [command] [argument]
```

## Commands

| Command | Arguments | Behavior |
| --- | --- | --- |
| `menu` | None | Opens the interactive dashboard |
| `setup` | None | Installs the launcher and copies runtime files to Termux |
| `install` | None | Installs or resumes the selected Linux desktop |
| `start` | Optional distro, `--desktop KEY`, `--nogpu`, `--legacy`, `--debug` | Starts a selected desktop through Termux:X11 |
| `stop` | None | Stops the process recorded by REDMUX and its managed X11 process |
| `restart` | None | Runs the stop workflow, then starts the configured desktop |
| `shell` | Optional distribution alias | Opens a PRoot-Distro login shell |
| `environments` / `env` | None | Displays PRoot-Distro environment information |
| `desktop` | None | Changes the default desktop environment |
| `status` | None | Displays configuration and recorded session state |
| `config` | None | Opens configuration options |
| `config export` | File path | Exports the validated configuration |
| `config import` | File path | Imports recognized settings without executing the file |
| `config reset` / `reset` | None | Restores default settings without deleting Linux environments |
| `autostart enable/disable/status` | Action | Manages an optional Termux:Boot entry |
| `diagnose` / `doctor` | None | Checks required commands, storage, graphics capabilities, and installer state |
| `graphics` | None | Reports detected graphics helpers and the selected rendering profile |
| `apps search` | Query | Searches the guest APT package index |
| `apps install` | Package names | Installs guest packages through APT |
| `apps remove` | Package names | Removes guest packages through APT |
| `apps list` | None | Lists installed guest packages |
| `themes install` | None | Installs a curated GTK theme, icon, and font set |
| `wine-install` | None | Installs Wine and Winetricks when packages exist for the guest architecture |
| `wine-run` | Executable and arguments | Runs a Windows executable through Wine |
| `api-install` | None | Installs the Termux:API command-line package |
| `gui --start` | `x11` or `vnc` | Starts the selected display backend |
| `gui --stop` | `x11` or `vnc` | Stops the selected display backend |
| `gui --kill` | None | Stops REDMUX-managed X11 and the configured VNC display |
| `tx11start` | Startup options | Alias for the Termux:X11 desktop startup workflow |
| `tx11stop` | None | Alias for the managed X11 stop workflow |
| `vncstart` / `vncstop` | None | Short aliases for VNC start and stop |
| `vnc-install` | None | Installs the optional TigerVNC server in the selected guest |
| `vnc-start` | Optional distribution alias | Starts the configured localhost-only VNC desktop |
| `vnc-stop` | Optional distribution alias | Stops the configured VNC display |
| `vnc-status` | Optional distribution alias | Lists VNC sessions in the selected guest |
| `tx11start` / `tx11stop` | Startup options / none | Termux:X11 aliases |
| `vncstart` / `vncstop` | None | VNC aliases |
| `logs` | None | Displays the latest 100 log lines |
| `uninstall` | None | Opens the guarded removal workflow |
| `version` | None | Prints the application version |
| `help` | None | Prints command help |

## Examples

```bash
redmux
redmux install
redmux start
redmux start ubuntu
redmux shell ubuntu
redmux status
redmux diagnose
redmux logs
```

Supported distribution aliases are `debian`, `ubuntu`, and `kali`. Supported desktop keys include `xfce`, `kde`, `lxqt`, `mate`, `lxde`, `gnome`, `openbox`, `i3`, `cinnamon`, `dwm`, `bspwm`, `awesome`, `fluxbox`, `icewm`, and `wmaker`. Package and session availability still depends on the selected guest distribution.

## Session stop behavior

REDMUX records the PID of the session process it starts. When `setsid` is available, the process is started in a separate process group so the stop command can signal that group. Without `setsid`, REDMUX signals only the recorded process. REDMUX does not search for and terminate desktop processes by broad process-name patterns. An X11 process is stopped only when its PID was recorded by REDMUX; an X11 server started independently is left alone.

## Dashboard options

The dashboard accepts `01` through `10`. Enter `00` or `0` to exit. Single-digit selections are also accepted.
