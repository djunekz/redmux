# Desktop Environment Support

Desktop environment definitions are currently maintained in `core/desktop.sh`. This directory is reserved for future desktop-specific modules and compatibility notes.

## Supported desktop keys

| Key | Desktop | Package verification |
| --- | --- | --- |
| `xfce` | XFCE4 | `xfce4-session` |
| `kde` | KDE Plasma | `plasma-workspace` |
| `lxqt` | LXQt | `lxqt-session` |
| `mate` | MATE | `mate-session-manager` |
| `lxde` | LXDE | `lxsession` |
| `gnome` | GNOME | `gnome-session` |

Package names and session commands are distribution-release dependent. A successful package check does not guarantee that every desktop component works under PRoot. Record device, Android, Termux, distribution, and desktop details when reporting compatibility results.
