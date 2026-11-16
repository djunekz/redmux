# Release Checklist

- [ ] Update the changelog with user-visible changes.
- [ ] Confirm the version in `core/utils.sh` and help output.
- [ ] Run `bash -n redmux`.
- [ ] Run syntax checks for every shell file in `core/` and `modules/`.
- [ ] Verify executable permissions for the entry point.
- [ ] Verify `assets/banner.txt` exists for the terminal banner.
- [ ] Verify `assets/menu.svg` renders in the GitHub README preview and is not copied by the Termux installer.
- [ ] Run `bash tests/test-ui.sh` and inspect the dashboard at narrow and wide terminal widths.
- [ ] Run `./redmux setup` in a test Termux environment.
- [ ] Confirm the installed copy contains only runtime files and the terminal banner.
- [ ] Test dashboard navigation and invalid input handling.
- [ ] Test install/resume, diagnostics, session start/stop, and uninstall safeguards on a real device.
- [ ] Review README links and GitHub issue templates.
- [ ] Tag and publish the release only after device testing.
