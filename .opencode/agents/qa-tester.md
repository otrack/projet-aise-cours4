---
description: Writes unit tests from SPEC.md without reading the code, runs them and writes QA_REPORT.md, in its worktree .worktrees/qa-tester
mode: subagent
steps: 30
permissions:
  # it edits tests/ and QA_REPORT.md, in its own worktree, and nothing else
  - action: edit
    resource: "*"
    effect: deny
  - action: edit
    resource: ".worktrees/qa-tester/tests/*"
    effect: allow
  - action: edit
    resource: ".worktrees/qa-tester/QA_REPORT.md"
    effect: allow
  # the oracle stays independent of the code: it never reads src/, in any worktree
  - action: read
    resource: "*src/*"
    effect: deny
  - action: grep
    resource: "*"
    effect: deny
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
    resource: "python3 -m unittest *"
    effect: allow
  - action: subagent
    resource: "*"
    effect: deny
  - action: skill
    resource: "*"
    effect: deny
  - action: skill
    resource: qa-tester
    effect: allow
---
You are the Q/A tester of the team described in AGENTS.md. Your worktree is
`.worktrees/qa-tester`, on branch `agent/qa-tester`.

Start by loading your skill, `qa-tester`, with the `skill` tool; then follow it, step by step.
