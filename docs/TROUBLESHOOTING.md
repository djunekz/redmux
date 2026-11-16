# Troubleshooting

## Collect diagnostic information

Run:

```bash
redmux version
redmux status
redmux diagnose
redmux logs
proot-distro list
```

Remove usernames, private paths, tokens, and other sensitive details before sharing output.

## PRoot-Distro is unavailable

Run `redmux install` and accept the prompt to install PRoot-Distro. If Termux cannot download packages, check the configured Termux repositories and network connection, then run `pkg update` and retry.

## Distribution download or installation fails

Check free storage and network stability. PRoot-Distro controls root filesystem retrieval. Read the first reported error, resolve it, and retry. Do not manually delete PRoot-Distro data directories unless you understand the consequences.

## APT reports broken packages

Read the first package-manager error, not only the final summary. Possible causes include interrupted dpkg configuration, stale package indexes, unavailable mirrors, unsupported package names, and low storage. Resolve the reported cause, then run `redmux install` again.

## Desktop package verification fails

Check whether the required package exists in the selected distribution release. Desktop metapackages and session package names can differ between releases. Include the complete package installation output in a bug report.

## Termux:X11 is unavailable

Confirm that the Termux-side package providing `termux-x11` is installed. Install and open the Android Termux:X11 application separately. The Android application is not installed by REDMUX.

## The desktop does not appear

Open the Android Termux:X11 application, verify the configured display in `redmux config`, and check Android background restrictions. Review `redmux logs` and `redmux diagnose` for errors.

## The session stops unexpectedly

Some desktop environments expect systemd, logind, dbus services, or hardware access that PRoot cannot fully provide. Try a lighter desktop such as XFCE4 and include the session log when reporting the issue.

## `redmux stop` does not stop an independently started session

REDMUX only signals the process ID recorded when it starts a session. Sessions started manually or by another tool must be stopped using that tool or from the Linux environment. This prevents REDMUX from terminating unrelated desktop processes.
