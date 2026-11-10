# AGENTS.md

## Team
This project is built by a team of AI agents, from a one-line idea: a lead and four subagents.

| agent | role |
|---|---|
| `lead` | runs the team: calls each subagent in turn, then merges its branch into `main`; never edits a file |
| `product-manager` | turns the idea into `SPEC.md` |
| `coder` | implements `SPEC.md` |
| `qa-tester` | writes the tests from `SPEC.md`, **without reading the code**, runs them, reports |
| `reviewer` | reads everything, gives a verdict |

Each agent is defined in `.opencode/agents/<agent>.md` (a description, its permissions, a prompt);
the know-how of each subagent is its skill, `.opencode/skills/<agent>/SKILL.md`.

## Who owns which file
A file has a single owner: only its owner edits it; every agent may read it, except that the
qa-tester never reads `src/`. The permissions of each agent enforce this table.

| file | owner |
|---|---|
| `SPEC.md` | product-manager |
| `src/<module>.py` | coder |
| `tests/test_<module>.py`, `QA_REPORT.md` | qa-tester |
| `REVIEW.md` | reviewer |
| everything else (`AGENTS.md`, `README.md`, `.opencode/`, ...) | the humans: never edit it |

## Git protocol
- each subagent works in its own git worktree, `.worktrees/<agent>`, on its own branch,
  `agent/<agent>`; the root directory is `main`, where the lead works
- the agents exchange their work only through `main`:
  1. before working, the subagent brings `main` into its branch: `git merge main`
  2. when done, it commits its own files: `git add <its files>`, then
     `git commit -m "[<agent>] <what it did>"`
  3. the lead then merges the branch into `main`: `git merge --no-ff --no-edit agent/<agent>`
- a subagent runs every shell command with the `workdir` of the shell tool set to its worktree,
  and gives every file path from the root: `.worktrees/<agent>/SPEC.md`, not `SPEC.md`

## Conventions
- Python 3.10 or later, standard library only
- the module is `src/<module>.py`, where `<module>` is a short snake_case name chosen in `SPEC.md`
- type hints and a one-line docstring on every function
- tests: unittest, in `tests/test_<module>.py`, which imports the module with
  `from src.<module> import ...`; run them from the root of a worktree with
  `python3 -m unittest discover -s tests -v`
