# Frequently Asked Questions

## Does REDMUX install the Android Termux:X11 application?

No. The Android application must be installed separately. REDMUX can offer to install the Termux-side package that provides the `termux-x11` command.

## Can I install more than one desktop environment?

Yes. During installation, enter comma-separated desktop selections such as `1,3`. REDMUX installs the selected package sets and offers installed configured desktops when starting a session.

## Can I run REDMUX without installing its command globally?

Yes. From the source checkout, run `bash redmux`. Run `./redmux setup` to install the `redmux` command in Termux.

## Does uninstall delete my Git repository?

No. The uninstall workflow removes the installed REDMUX copy and, if explicitly selected and confirmed, Linux distribution filesystems. It does not delete the source repository.

## Why might a desktop fail under PRoot?

Some desktop components expect systemd, logind, kernel features, or background services that PRoot cannot fully provide. Package availability and compatibility also vary by distribution release and device.

## Does the progress indicator show exact download bytes?

No. The installer progress indicator represents workflow stages. PRoot-Distro and APT display their own download and package progress.

## What does `redmux stop` stop?

It signals the desktop process started and recorded by REDMUX and stops the Termux:X11 process only when REDMUX started and recorded it. It does not kill unrelated desktop processes by name.

## What is the current version?

The current development package reports version `1.0.0`. New work is recorded under the Unreleased section of the changelog.
