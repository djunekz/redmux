# Security Policy

## Supported version

Security reports should target the current development version, **1.0.0**. The project version remains unchanged until an official release.

## Reporting a vulnerability

Please do not publish exploitable vulnerabilities in a public issue. Contact the repository maintainer privately through the contact method listed on the GitHub repository profile. Include:

- A concise description and potential impact.
- Affected files, commands, and configuration.
- Reproduction steps or a minimal proof of concept.
- Relevant device, Android, Termux, and PRoot-Distro versions.
- Any suggested mitigation.

Do not include passwords, access tokens, private keys, or unrelated personal data.

## Scope and safety notes

REDMUX executes commands in Termux and invokes PRoot-Distro and package managers. Treat installation scripts and third-party package repositories as privileged within the user's Termux data. Review changes before running them. Uninstall operations must never delete the user's source checkout and must clearly identify any Linux filesystem scheduled for removal.

We will acknowledge reports as soon as practical and coordinate a fix and disclosure timeline with the reporter.
