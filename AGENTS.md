# AGENTS.md — Ground Rules for homebrew-tap

This file defines the non-negotiable standards for all contributors (human or AI) working on this repository.

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
