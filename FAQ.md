# Frequently Asked Questions

## Does REDMUX install Android Termux:X11 automatically?

REDMUX can prepare the Termux-side CLI package. The Android application must be installed separately.

## Can I install more than one desktop environment?

Yes. Select multiple desktop entries during installation using comma-separated numbers. The installer combines the selected package lists and the session menu offers the detected installed desktops when more than one is configured.

## Can I use REDMUX without installing its command globally?

Yes. Run `./redmux` from the source checkout. Run `./redmux setup` to install the `redmux` command into Termux.

## Does uninstall delete my Git repository?

No. REDMUX uninstall operations must not delete the cloned source repository. Full clean uninstall can remove selected Linux distribution filesystems after explicit confirmation.

## Why might a desktop fail under PRoot?

Some desktop components expect systemd, logind, kernel features, or background services that PRoot cannot fully provide. Package availability and compatibility also vary by distribution release.

## Does the progress bar show exact download bytes?

No. The REDMUX progress indicator represents workflow stages. PRoot-Distro and APT provide their own download/package progress output.

## Is version 1.0.0 changing?

No version increment is made until an official release is announced.
