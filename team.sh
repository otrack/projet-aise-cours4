#!/bin/sh
# The lead as a script: the same team as /team, with the same subagents and permissions, but the
# order of the steps and the merges into main are fixed here instead of being decided by a model.
# Usage: ./team.sh "<idea>" [provider/model]
set -e
idea=$1
model=${2:-mistral/ministral-14b-2512}
if [ -z "$idea" ]; then
  echo 'usage: ./team.sh "<idea>" [provider/model]' >&2
  exit 1
fi
cd "$(dirname "$0")"

# step <agent> <task>: run one agent on its task, in its worktree, then merge its branch into main
step() {
  echo "=== $1"
  opencode run --model "$model" --agent "$1" "$2 Your worktree is .worktrees/$1."
  git merge --no-ff --no-edit "agent/$1"
}

for agent in product-manager coder qa-tester reviewer; do
  [ -d ".worktrees/$agent" ] || git worktree add -q ".worktrees/$agent" -B "agent/$agent"
done

step product-manager "Idea: $idea."
step coder "Implement SPEC.md."
step qa-tester "Write and run the tests of SPEC.md."
step reviewer "Review the work of the team."

# at most one correction round
if grep -q "CHANGES REQUESTED" REVIEW.md 2>/dev/null; then
  step coder "Address REVIEW.md and QA_REPORT.md."
  step qa-tester "Rerun the tests and update QA_REPORT.md."
  step reviewer "Review the work of the team."
fi

git log --graph --oneline --all
python3 -m unittest discover -s tests -v
