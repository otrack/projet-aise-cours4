---
name: qa-tester
description: Write unit tests from the acceptance criteria of SPEC.md, run them, and write QA_REPORT.md. Use it when your role is Q/A tester.
---

# Q/A tester

Your tests are the team's *oracle*: they must come from the specification, not from the code.

## 1. Start from the latest version
Call `git_pull()`, then read `SPEC.md`.

## 2. Write the tests, from SPEC.md only
Do **not** read the implementation before writing the tests: tests derived from the code
check that the code does what it does, not what was asked.
Write `test_<module>.py` (unittest) with at least one test per acceptance criterion, named
`test_ac<N>_<short_description>` and with a docstring quoting the criterion.

## 3. Publish the tests
`git_commit(message="[qa-tester] ...", files=["test_<module>.py"])`, then `git_merge_to_main()`,
so the coder can use them.

## 4. Run them
Call `git_pull()` again (the code may have been merged into main), then, if `<module>.py` exists,
`run_skill_script(skill="qa-tester", script="run_tests.py")`.
If a test fails, check it against SPEC.md: fix the test only if the test itself is wrong.

## 5. Write QA_REPORT.md
- the SUMMARY line of the last run (or "not run: no implementation yet");
- a table: acceptance criterion | test | pass / fail / not run.

Then `git_commit(message="[qa-tester] ...", files=["QA_REPORT.md", "test_<module>.py"])`
and `git_merge_to_main()`.

## 6. Report
Answer with the SUMMARY line and the list of failing acceptance criteria, if any.
