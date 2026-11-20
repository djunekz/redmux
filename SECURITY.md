# Security Policy

## Supported version

Security reports should target the current development version. The current development version is `1.0.0`; verify the version output before reporting a security issue.

## Reporting a vulnerability

Do not publish exploitable vulnerabilities in a public issue. Contact the repository maintainer privately using the contact method listed on the GitHub repository profile. Include:

- A concise description and potential impact.
- Affected files and commands.
- Reproduction steps or a minimal proof of concept.
- Relevant Android, Termux, and PRoot-Distro versions.
- Any suggested mitigation.

Do not include passwords, access tokens, private keys, or unrelated personal data.

## Scope and safety

REDMUX executes commands in Termux and invokes PRoot-Distro and package managers. Review installation scripts and third-party package sources before running them. Uninstall operations must never delete the source checkout and must clearly identify any Linux filesystem scheduled for removal.

The maintainers will acknowledge reports as soon as practical and coordinate remediation and disclosure with the reporter.
