# Installation Guide

## Requirements

- Termux on a supported Android device.
- A working network connection.
- Several gigabytes of free storage for a Linux desktop, depending on the selected environment.
- The Termux:X11 Android application and its Termux-side command-line package for graphical sessions.

## Install REDMUX

Run these commands in Termux:

```bash
pkg update
pkg install git
git clone https://github.com/djunekz/redmux.git
cd redmux
chmod +x redmux
./redmux setup
```

The setup command installs `$PREFIX/bin/redmux` and copies runtime files to `$PREFIX/share/redmux`. The README artwork is not installed.

To run directly from the checkout without installing the launcher:

```bash
bash redmux
```

## Install a Linux desktop

```bash
redmux install
```

Choose a supported distribution and one or more desktop environments. REDMUX checks dependencies and storage before starting. Keep Termux open while APT and dpkg are working. Do not interrupt package configuration.

If a stage fails, read the package-manager output, fix the reported issue, and run `redmux install` again. Completed stages are reused only for the same saved distribution and desktop selection.

## Start a graphical session

1. Install and open the Android Termux:X11 application.
2. Ensure the Termux-side `termux-x11` command is available.
3. Run:

```bash
redmux start
```

## Refresh or remove REDMUX

Run `./redmux setup` again from the source checkout to refresh the installed runtime files. Use `redmux uninstall` to remove the installed application or selected Linux environments. The source checkout is not removed by the uninstall workflow.

## Installation boundaries

REDMUX uses PRoot-Distro and does not install a separate Linux kernel or full virtual machine. Package names and desktop behavior vary by distribution release. Successful installation does not guarantee that every desktop feature works on every Android device.
