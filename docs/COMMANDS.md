# Command Reference

REDMUX supports both an interactive dashboard and direct command-line operations.

## Syntax

```text
redmux [command] [argument]
```

## Commands

| Command | Arguments | Behavior |
| --- | --- | --- |
| `menu` | none | Opens the interactive dashboard |
| `setup` | none | Copies runtime files (not README artwork) to the Termux share directory and installs the launcher |
| `install` | none | Runs or resumes the Linux desktop installer |
| `start` | optional distribution alias | Starts the selected desktop using Termux:X11 |
| `stop` | none | Stops matching desktop session processes and the REDMUX-managed X11 process |
| `restart` | none | Runs `stop` followed by `start` |
| `shell` | optional distribution alias | Opens a PRoot-Distro login shell |
| `environments` | none | Displays PRoot-Distro environment information |
| `desktop` | none | Changes the default desktop environment |
| `status` | none | Displays configured values and detected session state |
| `config` | none | Opens configuration controls |
| `diagnose` / `doctor` | none | Runs environment diagnostics |
| `logs` | none | Shows the most recent log entries |
| `uninstall` | none | Opens removal options |
| `version` | none | Prints the version |
| `help` | none | Prints usage information |

## Examples

```bash
redmux
redmux install
redmux start
redmux shell ubuntu
redmux status
redmux diagnose
redmux logs
```

Distribution aliases currently accepted by REDMUX are `debian`, `ubuntu`, and `kali`.
