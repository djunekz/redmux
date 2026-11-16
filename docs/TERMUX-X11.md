# Termux:X11 Setup

REDMUX uses Termux:X11 to display Linux desktop applications on Android. The Android application and the Termux-side command-line package are separate components.

## Setup checklist

1. Install the Termux:X11 Android application from its official project distribution channel.
2. Install the matching Termux-side package that provides the `termux-x11` command, following the Termux:X11 project instructions.
3. Open the Android Termux:X11 application.
4. Complete a REDMUX Linux and desktop installation.
5. Start the desktop from Termux:

```bash
redmux start
```

## Session management

```bash
redmux status
redmux stop
redmux start
```

REDMUX uses the configured display value, which defaults to `:1`. Change it through `redmux config` if the environment requires a different display.

## Troubleshooting

- If the command is missing, verify that the Termux-side package is installed.
- If no window appears, open the Android application and check Android background restrictions.
- If the session exits, inspect `redmux logs` and `redmux diagnose`.
- Keep the Android application and Termux-side package versions compatible.

Consult the Termux:X11 project documentation for current installation instructions. REDMUX does not distribute or maintain the Android application.
