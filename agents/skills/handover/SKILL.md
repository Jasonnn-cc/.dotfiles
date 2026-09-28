---
name: handover
description: Write a handover document for work in progress.
disable-model-invocation: true
---

Write a handover: everything the next agent needs to carry this work forward, and nothing the repo already tells them. Write it to the path given in the arguments; `HANDOVER.md` in the working directory when none is given.

## The cache test

A handover is a **cache** of what the repo cannot be read for. The code, the diff, and the git log are the source of truth for _how_ the work is built; the handover holds the _why_ and the _what's left_, which live only in this session and die with it. Before writing any line, ask whether the next agent could derive it by reading the code. If they could, cut it.

Files and symbols appear as **pointers** only — "the retry path lives in `client.py`" — never as descriptions of how they work.

## Legwork

Reconstruct the state from the environment rather than from memory: `git status`, the diff, this branch's commits against its parent, the test run, anything left half-applied. Then reread the session for the material the environment cannot hold — decisions taken, options rejected, constraints discovered.

## Sections

Write every section; drop one only when it is genuinely empty.

- **Goal** — what the work must achieve, and the criterion that says it is done.
- **State** — what has landed, what is half-built, what is untouched.
- **Decisions** — each decision settled, the option taken, and why. Give the rejected options with the reason for rejecting them; a rejected option that arrives without its reason gets relitigated.
- **Constraints** — what the work must live within: environment facts, gotchas, approaches already tried and abandoned. Anything the next agent would otherwise rediscover the hard way.
- **Open questions** — decisions still unsettled, each with what it blocks and your recommended answer.
- **Next steps** — ordered, each with its own completion criterion.

## Done when

Every decision this session made appears with its reason, every open question is named, and the first next step is actionable without asking you anything.

Read the document back as someone who has never seen this work: anything you could not act on is missing, and anything you could have got from the code is surplus.
