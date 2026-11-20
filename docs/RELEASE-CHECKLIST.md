# Release Checklist

## Source and version

- [ ] Confirm the intended version and update `REDMUX_VERSION` in `core/utils.sh`.
- [ ] Update the version displayed by `redmux help`.
- [ ] Record user-visible changes in `CHANGELOG.md`.
- [ ] Review every changed file and remove temporary or generated artifacts.

## Static validation

- [ ] Run `bash -n` for `redmux`, every script in `core/`, `modules/`, and `tests/`.
- [ ] Run `bash tests/test-ui.sh` at the supported terminal widths.
- [ ] Run `bash tests/test-config.sh` to validate safe configuration loading.
- [ ] Run `bash tests/test-setup.sh` to verify the installed file boundary.
- [ ] Run `bash tests/test-session-safety.sh` to verify unrelated processes are not signalled.
- [ ] Run `bash tests/test-entrypoint.sh` to verify every command in the entry point resolves to a loaded function.
- [ ] Validate relative Markdown links.
- [ ] Validate GitHub issue-template YAML.
- [ ] Validate `assets/logo.svg` and `assets/menu.svg` as XML.
- [ ] Verify executable permissions for the entry point and test script.

## Runtime validation

- [ ] Verify `./redmux setup` in a disposable Termux environment.
- [ ] Confirm only runtime files and `assets/banner.txt` are copied to the installed directory.
- [ ] Test dashboard navigation, invalid input, help, version, and logs.
- [ ] Test configuration validation and safe configuration loading.
- [ ] Test install/resume and failed-stage recovery.
- [ ] Test desktop start/stop and confirm unrelated processes remain untouched.
- [ ] Test diagnostics and guarded uninstall on a disposable environment.
- [ ] Test Termux:X11 and each claimed desktop on a real Android device.

## Release publication

- [ ] Review README links and GitHub issue templates.
- [ ] Review the changelog and release notes.
- [ ] Confirm the source checkout is not removed by uninstall flows.
- [ ] Tag and publish only after required device tests pass.
