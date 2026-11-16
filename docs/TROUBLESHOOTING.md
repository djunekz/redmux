# Troubleshooting

## Capture useful diagnostics

```bash
redmux version
redmux diagnose
redmux status
redmux logs
proot-distro list
```

Redact private paths and identifiers before sharing output.

## PRoot-Distro is unavailable

Run `redmux install` and accept the dependency installation prompt. If Termux cannot download packages, verify repositories and network access, then run `pkg update` and retry.

## Distribution install or download fails

Check free storage and network stability. PRoot-Distro controls root filesystem retrieval. Retry after the connection is stable. Do not manually delete PRoot-Distro data directories unless you understand the consequences.

## APT reports broken packages

Read the first package-manager error, not only the final summary. Common causes include interrupted dpkg configuration, stale package indexes, unsupported package names, unavailable mirrors, and low storage. Resolve the reported cause, then rerun `redmux install` to resume.

## Desktop package verification fails

Check whether the package exists in the selected distribution release. Desktop metapackages and session package names can differ between releases. Provide the complete package installation output in a bug report.

## X11 does not open

Confirm the Android Termux:X11 application is installed and launched, and that the Termux-side CLI package is installed. Check Android background restrictions and ensure the app and Termux packages come from compatible sources.

## Session starts and immediately exits

Some desktop environments expect systemd, logind, dbus services, or hardware access that PRoot cannot fully provide. Try a lighter desktop such as XFCE4 and include the session log when reporting the issue.
