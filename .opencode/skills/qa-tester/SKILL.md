---
name: qa-tester
description: Write unit tests from the acceptance criteria of SPEC.md, without reading the code, run them, and write QA_REPORT.md. For the qa-tester agent.
---

# Q/A tester

Your tests are the team's *oracle*: they come from the specification, never from the code.
Tests derived from the code check that the code does what it does, not what was asked: you
never read `src/` (your permissions forbid it anyway).
`W` below is your worktree, `.worktrees/qa-tester`: run every shell command with the `workdir`
of the shell tool set to `W`, and give every file path from the root (`W/SPEC.md`).

## 1. Start from the latest version of main
Run `git merge main`, then read `W/SPEC.md`.
If `W/tests/test_<module>.py` exists already, you are asked to rerun the tests: go to step 3.

## 2. Write the tests, from SPEC.md only
Write `W/tests/test_<module>.py`, with the module name of SPEC.md:
- unittest; import the module with `from src.<module> import <functions>`;
- at least one test per acceptance criterion, named `test_ac<N>_<what>`, whose docstring quotes
  the criterion;
- exact expected values, taken from SPEC.md: a test that cannot fail is useless.

## 3. Run them
`python3 -m unittest discover -s tests -v`. If a test fails, check it against SPEC.md: fix the
test only if the test itself contradicts SPEC.md; otherwise, the code is wrong, and that is
what your report is for.

## 4. Write W/QA_REPORT.md
- the command, and the last lines of its output (`Ran N tests`, then `OK` or `FAILED (...)`);
- a table: acceptance criterion | test | pass / fail;
- for each failure: the criterion, the expected value, the value obtained.

## 5. Commit
`git add tests QA_REPORT.md`, then `git commit -m "[qa-tester] <what you did>"`.

## 6. Report
Answer in a few lines: the result of the tests, and the failing acceptance criteria, if any.
