# Contributing to REDMUX

Thank you for considering a contribution. Bug reports, tested compatibility notes, documentation fixes, and focused code changes are welcome.

## Before you start

- Read the README and relevant files under `docs/`.
- Search existing issues before opening a new one.
- Keep changes focused and explain the user-visible problem they solve.
- Do not change the project version from `1.0.0` unless the maintainer explicitly announces a release.

## Development principles

- Target Termux Bash and Android constraints; do not assume a conventional systemd-based Linux host.
- Preserve the user's cloned source repository during all uninstall flows.
- Do not silently delete Linux distributions, configuration, or user data.
- Quote shell variables, check command failures, and make destructive actions require explicit confirmation.
- Keep user-facing messages and documentation in English.
- Avoid adding dependencies unless they materially improve reliability and are documented.
- Do not add shell comments unless required for interpreter directives or otherwise agreed by maintainers.

## Testing checklist

Run syntax checks for every shell script:

```bash
find . -type f -name '*.sh' -o -name redmux | while read -r file; do bash -n "$file" || exit 1; done
```

Also verify, where practical:

- The main menu and `redmux help` render in Termux and plain-text output.
- Missing dependencies produce a clear opt-in installation prompt.
- Existing PRoot-Distro environments are detected correctly.
- Failed installer stages are not marked complete.
- Re-running installation resumes only matching saved state.
- Start/stop behavior does not terminate unrelated user processes.
- Uninstall never removes the source checkout.

Runtime testing should be performed on a real Termux device when a change touches PRoot-Distro, APT, Android intents, or Termux:X11. Clearly state what was and was not tested in pull requests.

## Pull requests

Include:

1. A concise problem statement.
2. The approach and important design decisions.
3. Test commands and their results.
4. Device/Android/Termux details for runtime-sensitive changes.
5. Screenshots or terminal recordings for significant UI changes, with private information redacted.

Do not include personal tokens, private keys, account identifiers, or unredacted home-directory details.
