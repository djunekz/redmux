# Contributing to REDMUX

Thank you for considering a contribution. Bug reports, tested compatibility notes, documentation fixes, and focused code changes are welcome.

## Before you start

- Read the README and the relevant guides under `docs/`.
- Search existing issues before opening a new one.
- Keep changes focused and explain the user-visible problem they solve.
- Do not change the project version unless the maintainer announces a release.

## Development principles

- Target Termux Bash and Android constraints; do not assume a conventional systemd-based Linux host.
- Preserve the user's source repository during every uninstall flow.
- Do not silently delete Linux distributions, configuration, or user data.
- Quote shell variables, check command failures, and require explicit confirmation for destructive actions.
- Keep user-facing messages and documentation in English.
- Avoid adding dependencies unless they materially improve reliability and are documented.
- Do not add explanatory comments to shell code unless required for interpreter directives or explicitly requested by the maintainer.

## Testing

Run the following from the repository root:

```bash
find . -type f \( -name '*.sh' -o -name redmux \) -print0 | while IFS= read -r -d '' file; do bash -n "$file" || exit 1; done
bash tests/test-ui.sh
bash tests/test-config.sh
bash tests/test-setup.sh
bash tests/test-session-safety.sh
bash tests/test-features.sh
bash tests/test-management.sh
bash tests/test-entrypoint.sh
```

Also verify, where practical:

- The dashboard and `redmux help` render in Termux and plain-text output.
- Narrow terminal output does not wrap or misalign.
- Missing dependencies produce a clear opt-in installation prompt.
- Invalid configuration values are ignored and configuration content is not executed.
- Failed installer stages are not marked complete.
- Re-running installation resumes only matching saved state.
- Session stop targets only REDMUX-managed process IDs.
- Uninstall never removes the source checkout.

Runtime testing is required for changes involving PRoot-Distro, APT, Android intents, or Termux:X11. State clearly what was and was not tested.

## Pull requests

Include:

1. A concise problem statement.
2. The approach and important design decisions.
3. Test commands and their results.
4. Device, Android, and Termux details for runtime-sensitive changes.
5. Screenshots or terminal recordings for significant UI changes, with private information redacted.

Do not include personal tokens, private keys, account identifiers, or unredacted home-directory details.
