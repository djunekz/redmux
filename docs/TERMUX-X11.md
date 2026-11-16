# Termux:X11 Setup

Termux:X11 has two separate parts: the Android application and the Termux-side command-line package that provides `termux-x11`. Both are required for a graphical session.

## Setup

1. Install the Termux:X11 Android application using the official Termux:X11 project instructions.
2. In Termux, run `redmux diagnose` and check whether the `termux-x11` command is available.
3. If the command is missing, run `redmux start` or `redmux install` and accept the package installation prompt when offered.
4. Open the Android Termux:X11 application.
5. Start the configured desktop:

```bash
redmux start
```

The Android application is not installed by REDMUX. The Termux-side package and Android application must come from compatible project releases.

## Session commands

```bash
redmux status
redmux stop
redmux start
```

The default display is `:1`. Change it with `redmux config` if another display is required.

## Troubleshooting

- If `termux-x11` is missing, verify that the Termux-side package is installed and available in `PATH`.
- If no window appears, open the Android application and review Android background restrictions.
- If the session exits, inspect `redmux logs` and `redmux diagnose`.
- Check that the Android application and Termux-side package are compatible.

Consult the Termux:X11 project documentation for current installation instructions. REDMUX does not distribute or maintain the Android application.
