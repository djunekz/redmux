# Testing Guide

REDMUX interacts with Termux packages, PRoot-Distro, APT, Android applications, and desktop processes. Validate shell behavior separately from device integration.

## Static checks

Run from the repository root:

```bash
find . -type f \( -name '*.sh' -o -name redmux \) -print0 | while IFS= read -r -d '' file; do bash -n "$file" || exit 1; done
bash tests/test-ui.sh
bash tests/test-config.sh
bash tests/test-setup.sh
bash tests/test-session-safety.sh
bash tests/test-features.sh
bash tests/test-management.sh
bash tests/test-entrypoint.sh
```

The dashboard regression test renders the banner, section and step labels, dashboard, installation plan, stage indicator, and completion panel at several terminal widths. It checks that output lines stay within the selected width and that the expected menu entries remain visible.

## Installation smoke test

Use a disposable Termux environment:

1. Run `./redmux setup`.
2. Confirm `$PREFIX/bin/redmux` exists and is executable.
3. Confirm `$PREFIX/share/redmux/assets/banner.txt` exists.
4. Confirm `$PREFIX/share/redmux/assets/menu.svg` and `logo.svg` are not required or copied.
5. Run `redmux version` and `redmux help`.
6. Confirm configuration, state, and log directories are created.

## Configuration checks

- Confirm valid distribution, desktop, and display values are loaded.
- Confirm invalid values are ignored.
- Confirm unexpected shell statements in the configuration file are not executed.
- Confirm `redmux config` rejects display values that do not match `:NUMBER`.

## Session checks

On a test device, start a desktop through REDMUX and verify that `redmux status` reports the recorded session. Run `redmux stop` and confirm that only the recorded session and REDMUX-managed X11 process are signalled. Verify that independently started desktop and X11 processes remain untouched.

## Device integration

On a test device, validate distribution installation, desktop package installation, X11 startup, desktop launch, stop behavior, diagnostics, and uninstall confirmation. Do not use a production environment for destructive uninstall tests.

## Test limitations

Static checks do not verify package availability, root filesystem downloads, Android background behavior, graphics drivers, or desktop compatibility. Record Android version, device architecture, Termux source, distribution, desktop, and relevant logs when reporting a device-specific issue.
