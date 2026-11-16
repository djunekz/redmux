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
| `start` | Optional distribution alias | Starts the configured desktop through Termux:X11 |
| `stop` | None | Stops the process recorded by REDMUX and its managed X11 process |
| `restart` | None | Runs the stop workflow, then starts the configured desktop |
| `shell` | Optional distribution alias | Opens a PRoot-Distro login shell |
| `environments` / `env` | None | Displays PRoot-Distro environment information |
| `desktop` | None | Changes the default desktop environment |
| `status` | None | Displays configuration and recorded session state |
| `config` | None | Opens configuration options |
| `diagnose` / `doctor` | None | Checks required commands, storage, and installer state |
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

Supported distribution aliases are `debian`, `ubuntu`, and `kali`. Supported desktop keys are `xfce`, `kde`, `lxqt`, `mate`, `lxde`, and `gnome`.

## Session stop behavior

REDMUX records the PID of the session process it starts. When `setsid` is available, the process is started in a separate process group so the stop command can signal that group. Without `setsid`, REDMUX signals only the recorded process. REDMUX does not search for and terminate desktop processes by broad process-name patterns. An X11 process is stopped only when its PID was recorded by REDMUX; an X11 server started independently is left alone.

## Dashboard options

The dashboard accepts `01` through `10`. Enter `00` or `0` to exit. Single-digit selections are also accepted.
