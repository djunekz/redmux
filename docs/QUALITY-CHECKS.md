# Quality Checks

This document records the repeatable repository checks used before a release. It does not replace testing on a physical Android device.

## Automated checks

Run from the repository root:

```bash
find . -type f \( -name '*.sh' -o -name redmux \) -print0 | while IFS= read -r -d '' file; do bash -n "$file" || exit 1; done
bash tests/test-ui.sh
bash tests/test-config.sh
bash tests/test-setup.sh
bash tests/test-session-safety.sh
```

The tests cover:

- Dashboard, banner, installation plan, stage indicator, and completion panel widths from 24 to 80 columns.
- Valid and invalid configuration values, including a check that shell statements in the configuration file are not executed.
- The `setup` file boundary, including the rule that README SVG artwork is not copied into the Termux installation.
- Session-stop safety, confirming that unrelated processes are not signalled.

## Manual and device checks

Before publishing a release, verify package installation and recovery, PRoot-Distro behavior, Termux:X11 startup, desktop launch and stop, diagnostics, and destructive uninstall safeguards on a disposable Termux environment. Repeat graphics and background-process checks on the Android versions and device architectures the project claims to support.

## Limitations

Shell syntax checks and mocked setup tests cannot confirm package repository availability, root filesystem downloads, APT package compatibility, Android application behavior, graphics performance, or desktop stability under PRoot. Record these as device-test results rather than presenting static checks as full integration coverage.
