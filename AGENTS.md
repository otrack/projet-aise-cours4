# AGENTS.md

## Team
- this project is built by a team of AI agents; each one has a single role, described by its skill
- each agent works in its own git clone and communicates with the others **only through the
  repository**: the files below and the commits
- the project is initially empty

| File | Owner | Content |
|---|---|---|
| `SPEC.md` | product-manager | what to build: module, functions, acceptance criteria AC1, AC2, ... |
| `<module>.py` | coder | the implementation |
| `test_<module>.py` | qa-tester | unit tests, at least one per acceptance criterion |
| `QA_REPORT.md` | qa-tester | result of the last test run, per acceptance criterion |
| `REVIEW.md` | reviewer | verdict and review comments |
| `AGENTS.md`, `skills/` | humans | the team's rules and the roles: read them, never edit them |

- edit only the files your role owns; read all the others

## Git protocol
1. before starting: `git_pull()`
2. after your work: `git_commit(message="[<role>] <what you did>", files=[<your files>])`
3. `git_push()`; if it is rejected, `git_pull()` then `git_push()` again

## Conventions
- Python standard library only
- type hints and a one-line docstring on every function
- tests use unittest; run them with the script `run_tests.py` of your skill
