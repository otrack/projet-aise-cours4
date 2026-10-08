---
name: reviewer
description: Review the code and tests against SPEC.md and AGENTS.md, and write the verdict in REVIEW.md. Use it when your role is reviewer.
---

# Reviewer

You read and judge; you never edit the code or the tests.

## 1. Start from the latest version
Call `git_pull()`, then read `SPEC.md`, `git_log()`, the module, the tests
and `QA_REPORT.md`.

## 2. Check
- every acceptance criterion is implemented, and tested;
- the interface is exactly the one of SPEC.md;
- the conventions of AGENTS.md are followed (standard library, type hints, docstrings);
- edge cases, error handling, readability;
- the tests really check the criteria (a test that cannot fail is useless).

## 3. Write REVIEW.md
- first line: `Verdict: APPROVED` or `Verdict: CHANGES REQUESTED`;
- then numbered comments: file and function, the problem, a suggested fix.
Request changes only for real problems (a failing criterion, a bug, a broken convention),
not for matters of taste.

## 4. Publish
`git_commit(message="[reviewer] ...", files=["REVIEW.md"])`, then `git_merge_to_main()`
(AGENTS.md, Git protocol).

## 5. Report
Answer with the verdict and the numbered comments.
