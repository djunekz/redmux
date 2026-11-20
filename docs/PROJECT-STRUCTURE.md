# Project Structure

```text
redmux/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   └── PULL_REQUEST_TEMPLATE.md
├── assets/
│   ├── banner.txt
│   ├── logo.svg
│   └── menu.svg
├── config/
│   └── defaults.conf
├── desktops/
│   └── README.md
├── core/
│   ├── autostart.sh
│   ├── desktop.sh
│   ├── distro.sh
│   ├── graphics.sh
│   ├── session.sh
│   ├── software.sh
│   ├── utils.sh
│   ├── vnc.sh
│   └── x11.sh
├── docs/
├── modules/
│   ├── configuration.sh
│   ├── diagnostics.sh
│   ├── installer.sh
│   └── uninstaller.sh
├── tests/
│   ├── test-config.sh
│   ├── test-entrypoint.sh
│   ├── test-features.sh
│   ├── test-management.sh
│   ├── test-session-safety.sh
│   ├── test-setup.sh
│   └── test-ui.sh
├── .gitignore
├── CHANGELOG.md
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
├── FAQ.md
├── LICENSE
├── README.md
├── ROADMAP.md
├── SECURITY.md
├── SUPPORT.md
└── redmux
```

The entry point loads core services and feature modules, then dispatches the requested command. `core/` contains shared runtime behavior; `modules/` contains higher-level workflows; `assets/` contains terminal and repository artwork; `docs/` contains user and developer guides, including the repeatable quality-check procedure. `assets/menu.svg` and `assets/logo.svg` are repository-only artwork. `redmux setup` copies the terminal banner but not the SVG files.
