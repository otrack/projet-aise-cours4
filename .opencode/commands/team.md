---
description: Run the team of agents on an idea, e.g. /team a Python module to convert integers to Roman numerals
agent: lead
---
Run the team on this idea: $ARGUMENTS

The worktrees of the subagents:

!`for a in product-manager coder qa-tester reviewer; do [ -d .worktrees/$a ] || git worktree add -q .worktrees/$a -B agent/$a 2>&1; done; git worktree list`
