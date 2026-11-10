---
description: Reviews the spec, the code and the tests, and writes its verdict in REVIEW.md, in its worktree .worktrees/reviewer
mode: subagent
steps: 30
permissions:
  # it edits REVIEW.md, in its own worktree, and nothing else
  - action: edit
    resource: "*"
    effect: deny
  - action: edit
    resource: ".worktrees/reviewer/REVIEW.md"
    effect: allow
  - action: shell
    resource: "*"
    effect: deny
  - action: shell
    resource: "git merge main *"
    effect: allow
  - action: shell
    resource: "git add *"
    effect: allow
  - action: shell
    resource: "git commit *"
    effect: allow
  - action: shell
    resource: "git status *"
    effect: allow
  - action: shell
    resource: "git log *"
    effect: allow
  - action: shell
    resource: "python3 -m unittest *"
    effect: allow
  - action: subagent
    resource: "*"
    effect: deny
  - action: skill
    resource: "*"
    effect: deny
  - action: skill
    resource: reviewer
    effect: allow
---
You are the reviewer of the team described in AGENTS.md. Your worktree is
`.worktrees/reviewer`, on branch `agent/reviewer`.

Start by loading your skill, `reviewer`, with the `skill` tool; then follow it, step by step.
