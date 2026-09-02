# AGENTS.md — Ground Rules for homebrew-tap

This file defines the non-negotiable standards for all contributors (human or AI) working on this repository.

---

## Session startup

- At the **start of every agent session**, before acting from assumed conventions, read this `AGENTS.md` in full, then read every `alwaysApply: true` rule under `.cursor/rules/*.mdc` (plus any whose `globs` match files you will touch) — `AGENTS.md` and `.cursor/rules/` together are the contract. `CLAUDE.md` (a `@AGENTS.md` import) and `.github/copilot-instructions.md` are thin shims so Claude Code and Copilot reach the same guidance.

---

## Main worktree is off-limits (agents)

The **primary clone** (repo root — first entry in `git worktree list`, usually on branch `main`) is the **main worktree**. Treat it as **read-only** unless the user explicitly authorizes touching it in the current conversation.

**Never on the main worktree** (without explicit user authorization):

- Edit, create, or delete formulae, workflows, or other tracked files
- Run `git commit`, `git checkout`, branch creation, or other git write operations
- Leave uncommitted changes, stray branches, or detached HEAD state

**Always** do implementation and validation on a **feature branch**, preferably in a worktree under `.worktrees/<branch-name>-wt`.

`git fetch` / read-only inspection on `main` is fine. For isolated experiments, use a detached temporary worktree — not the primary clone.

---

## Pull requests

- All changes go through pull requests; do not push directly to `main`.
- Keep commits focused and GPG-signed when the repository requires it.

---

## Remote I/O

- **Remote timeouts and bounded retries:** `.cursor/rules/remote-timeouts-retries.mdc`
  (`alwaysApply`, org rule — template sync
  [repository-helpers#570](https://github.com/the-hcma/repository-helpers/issues/570)).
  Most network I/O is Homebrew's own (`url` download, `cargo install`) and stays
  as-is; anything we add — custom `curl` in a formula, release automation, CI
  helpers — uses explicit `--max-time` / `--connect-timeout`, bounded backed-off
  transient-only retries, and never re-sends a non-idempotent write.
