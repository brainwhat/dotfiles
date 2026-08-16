# Dotfiles agent instructions

## Apply VPS changes to every configured user

For every task that changes, installs, deploys, validates, or reloads software
or configuration on a VPS, first inspect the local SSH configuration and
enumerate every SSH alias and user for that VPS. Apply and validate the
requested change for every configured user unless the user explicitly limits
the scope. Do not assume that aliases or users documented in this repository
are exhaustive; discover them again for every task.

## Publish and deploy tracked configuration changes

Whenever an agent changes a configuration file that is already tracked by this
repository, the agent must finish the task by publishing and deploying that
change unless the user explicitly says not to:

1. Validate the changed configuration with the most relevant available check.
2. Preserve all unrelated local and remote changes. Never discard, overwrite,
   stage, or commit changes that are outside the current task.
3. Stage only the files changed for the current task and create a descriptive
   commit on the current branch.
4. Push the commit to `origin`.
5. Enumerate every SSH alias and user for the affected VPS from the local SSH
   configuration, then pull into every corresponding clone with rebase and
   autostash so account-local changes survive:

   ```sh
   ssh <vps-user-alias> 'git -C ~/.dotfiles pull --rebase --autostash'
   ```

6. Verify that every pull reached the pushed commit and that pre-existing dirty
   files remain present.
7. If the affected program supports safe live reload, validate and reload it on
   every affected account and machine. Otherwise, clearly state whether a new
   shell, tab, session, or process is required.

If a push, pull, autostash restoration, validation, or reload fails, stop and
report the exact failure. Do not force-push, reset, or overwrite local changes.

## Public repository safety

This repository is public. Do not add secrets, credentials, access tokens,
private keys, machine identities, authentication state, or private Codex/Claude
session data. A new untracked file is not automatically approved for publishing
just because it is a configuration file; inspect it and include it only when the
task requires it and it is safe for a public repository.
