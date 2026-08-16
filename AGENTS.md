# Dotfiles agent instructions

## Work through chezmoi

This repository is chezmoi source state. The standard source directory is
`~/.local/share/chezmoi`; managed files live at their rendered paths under
`$HOME`.

- Discover the active source directory with `chezmoi source-path`. Do not
  assume that a managed file's live path is a Git working tree.
- Prefer `chezmoi edit --apply <target>` or edit inside `chezmoi cd`. Before
  applying, inspect `chezmoi status`, `chezmoi diff --no-pager`, and
  `chezmoi apply --dry-run --verbose`.
- Treat pre-existing source changes and destination differences as user work.
  Preserve them and never apply over them blindly.
- When a live, untemplated file was edited directly, use `chezmoi re-add` only
  after reviewing the change. Use `chezmoi merge` for templates because
  `re-add` does not work with them.
- Keep caches, logs, databases, generated files, and authentication state out
  of the source directory. Remember that chezmoi reads untracked source files
  too; archive or ignore machine-local files before applying.

## Apply VPS changes to every configured user

For every task that changes, installs, deploys, validates, or reloads software
or configuration on a VPS, first inspect the local SSH configuration and
enumerate every SSH alias and user for that VPS. Apply and validate the
requested change for every configured user unless the user explicitly limits
the scope. Do not assume that aliases or users documented in this repository
are exhaustive; discover them again for every task.

## Publish and deploy tracked configuration changes

Whenever an agent changes a configuration file tracked by this repository, the
agent must finish the task by publishing and deploying that change unless the
user explicitly says not to:

1. Validate the rendered configuration with chezmoi and the most relevant
   program-specific check.
2. Record the local source state (`git status --short`) and destination state
   (`chezmoi status` and `chezmoi diff --no-pager`). Preserve all unrelated
   changes. Never discard, overwrite, stage, or commit files outside the task.
3. Stage only the source files changed for the task and create a descriptive
   commit on the current branch.
4. Push the commit to `origin`.
5. Enumerate every SSH alias and user for the affected VPS from the local SSH
   configuration. On every account, first record source and destination state,
   then pull without applying so destination changes can be reviewed:

   ```sh
   ssh <vps-user-alias> 'chezmoi git pull -- --rebase --autostash'
   ssh <vps-user-alias> 'chezmoi diff --no-pager'
   ```

6. Confirm that each source clone reached the pushed commit and that every
   pre-existing dirty or untracked source file survived. If the destination
   diff includes pre-existing user changes, preserve or merge them before
   continuing; do not run an unattended apply across them.
7. Validate the rendered remote configuration, then apply and verify it:

   ```sh
   ssh <vps-user-alias> 'chezmoi apply && chezmoi verify'
   ```

8. If the affected program supports safe live reload, validate and reload it
   on every affected account and machine. Otherwise, clearly state whether a
   new shell, tab, session, or process is required.

If a push, pull, autostash restoration, validation, apply, verification, or
reload fails, stop and report the exact failure. Do not force-push, reset, or
overwrite local changes.

## Bootstrap an uninitialized machine

Install chezmoi for the configured user and initialize the repository without
applying it immediately. Inventory and preserve any existing dotfile clone,
symlinks, live-file differences, generated state, and secrets. Review
`chezmoi diff --no-pager` and a dry run before the first apply. Use the standard
`~/.local/share/chezmoi` source directory unless the machine already has an
intentional chezmoi configuration.

## Public repository safety

This repository is public. Do not add secrets, credentials, access tokens,
private keys, machine identities, authentication state, or private
Codex/Claude session data. A new or untracked source file is not automatically
approved for publishing; inspect it and include it only when the task requires
it and it is safe for a public repository.
