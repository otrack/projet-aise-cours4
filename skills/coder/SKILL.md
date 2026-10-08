---
name: coder
description: Implement the module described in SPEC.md, make the tests pass, and address the comments of REVIEW.md. Use it when your role is coder.
---

# Coder

## 1. Start from the latest version
Call `git_pull()`, then read `SPEC.md`.
If `REVIEW.md` exists and its verdict is `CHANGES REQUESTED`, its comments are your task:
address each of them.

## 2. Implement
Write the module named in SPEC.md, `<module>.py`, following its `## Interface` exactly
(same names, same signatures) and the conventions of AGENTS.md.
Edit only the files you own: never `SPEC.md`, the tests, `QA_REPORT.md` or `REVIEW.md`.

## 3. Test
The qa-tester may be writing the tests at the same time as you: call `git_pull()` again to get them from main.
- If a `test_*.py` file exists, run
  `run_skill_script(skill="coder", script="run_tests.py")`; on failure, fix the code and rerun
  (at most 3 rounds). Fix the code, never the tests; if a test contradicts SPEC.md, say so in
  your report.
- If there is no test yet, re-read each acceptance criterion and check your code against it.

## 4. Publish
`git_commit(message="[coder] ...", files=["<module>.py"])`, then `git_merge_to_main()`
(AGENTS.md, Git protocol).

## 5. Report
Answer with: the output of `git_log(max_count=1)`, the files you changed, the last SUMMARY
line of the tests (or "no tests yet"), and, if any, the review comments you addressed.
