# Dotfiles agent instructions

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
5. Pull it into both VPS clones with rebase and autostash so machine-local
   changes survive:

   ```sh
   ssh AlphaVPS4G_cookit 'git -C ~/.dotfiles pull --rebase --autostash'
   ssh AlphaVPS4G_vstack 'git -C ~/.dotfiles pull --rebase --autostash'
   ```

6. Verify that both pulls reached the pushed commit and that pre-existing dirty
   files remain present.
7. If the affected program supports safe live reload, validate and reload it on
   every affected machine. Otherwise, clearly state whether a new shell, tab,
   session, or process is required.

If a push, pull, autostash restoration, validation, or reload fails, stop and
report the exact failure. Do not force-push, reset, or overwrite local changes.

## Public repository safety

This repository is public. Do not add secrets, credentials, access tokens,
private keys, machine identities, authentication state, or private Codex/Claude
session data. A new untracked file is not automatically approved for publishing
just because it is a configuration file; inspect it and include it only when the
task requires it and it is safe for a public repository.
