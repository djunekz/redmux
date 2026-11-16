# Testing Guide

REDMUX interacts with Termux packages, PRoot-Distro, APT, Android applications, and desktop session processes. Validate shell behavior separately from device integration.

## Static checks

Run from the repository root:

```bash
bash -n redmux
for file in core/*.sh modules/*.sh; do bash -n "$file" || exit 1; done
```

## Dashboard smoke test

Run `bash redmux` in Termux and confirm the dashboard appears as a single column with straight, aligned ASCII borders. Check both a narrow portrait terminal and a wider terminal. No menu label should cross a border or wrap into another menu item. Enter an invalid option and verify that REDMUX reports the valid range. Enter `0` to exit.

Run the layout regression test from the repository root:

```bash
bash tests/test-ui.sh
```

## Installation checks

In a disposable Termux test environment:

1. Run `./redmux setup`.
2. Confirm `$PREFIX/bin/redmux` exists and is executable.
3. Confirm `$PREFIX/share/redmux/assets/banner.txt` exists. `assets/menu.svg` and `assets/logo.svg` are repository/README artwork and must not be required by the installer.
4. Run `redmux version` and `redmux help`.
5. Confirm configuration and log directories are created.

## Device integration

On a test device, validate distribution installation, desktop package installation, X11 startup, desktop launch, stop behavior, diagnostics, and uninstall confirmation. Do not use a production environment for destructive uninstall tests.

## Test limitations

A successful syntax check does not verify package names, repository availability, root filesystem downloads, Android background behavior, graphics drivers, or desktop compatibility. Record Android version, architecture, Termux source, distribution, desktop, and relevant logs when reporting device-specific results.
