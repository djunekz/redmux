# Project Structure

```text
redmux/
├── .github/
│   ├── ISSUE_TEMPLATE/
│   ├── FUNDING.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── assets/
│   ├── banner.txt
│   ├── logo.svg
│   └── menu.svg  (README preview only)
├── config/
│   └── defaults.conf
├── desktops/
│   └── README.md
├── core/
│   ├── desktop.sh
│   ├── distro.sh
│   ├── session.sh
│   ├── utils.sh
│   └── x11.sh
├── docs/
├── modules/
│   ├── configuration.sh
│   ├── diagnostics.sh
│   ├── installer.sh
│   └── uninstaller.sh
├── tests/
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

The entry point loads core services and feature modules, then dispatches the requested command. The `core` directory contains shared runtime behavior; `modules` contains higher-level workflows; `assets` contains terminal and project artwork; `docs` contains user and developer documentation.
