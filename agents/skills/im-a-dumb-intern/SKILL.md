---
name: im-a-dumb-intern
description: Explain a topic, codebase area or concept as a published explainer page, grounded in the real code and written for a new hire.
disable-model-invocation: true
argument-hint: "What should I explain? (a topic, file, feature or concept)"
---

# I'm a dumb intern

Think of the user as a junior engineer or recently an intern, about to work on something they don't fully understand yet. Build them an **explainer**: one published Artifact page that teaches the topic as it exists in _this_ codebase. Write it for a **new hire**: someone sharp who can program, but hasn't met this repo's architecture or the industry's vocabulary for it.

The topic is `$ARGUMENTS`. If that's empty, the topic is whatever this session is working on: say it back in one line and carry on.

## 1. Pin the question

Settle, for yourself, the one question the page answers ("how does the watermark cache work, and why does the ClickHouse adapter need one?") and what the reader will do with the answer. Ask the user only when the topic could mean two different things in this repo.

Done when you can state the question and the reader's next task in one sentence each.

## 2. Ground it

Read the real thing: the code path end to end, the tests that pin its behaviour, the ADRs, plans and docs, and the commits that introduced it. Reuse what this session already established instead of re-deriving it. When a behaviour is cheap to observe (a query, a test run, a script in the scratchpad, a throwaway container), observe it. Leave the repo's files unchanged.

Done when every claim the page will make traces to a `file:line`, a command output or a doc you read, and you've listed the claims you couldn't verify. Those get labelled on the page.

## 3. Plan the page

- **You'll learn**: 3–5 outcomes, phrased as what the reader will be able to explain.
- **Jargon list**: every term the new hire will meet on the page, including the ones that feel basic (TTL, mutex, interface, offset, CQRS). Each gets a plain definition where it first appears, the name engineers use for it, and a glossary entry.
- **Sections**, in the order understanding builds: the general concept, how it works here, what's wrong or changing, how to change it. One idea per section.
- **Diagrams**: one for each mechanism the reader would otherwise have to piece together from prose.

Keep to what the reader needs for the question from step 1.

Done when every planned section serves that question and every jargon term has a home.

## 4. Build and publish

1. Call Artifact `quickstart` with intent `other`, as the Artifact tool requires before a new page.
2. Load the `artifact-diagramming` skill.
3. Read [STYLE.md](STYLE.md). Copy [template.html](template.html) into the scratchpad and fill it in.
4. Publish with a 2–4 word name as the title, a one-sentence description, and an `icon`.

Done when every item in the STYLE.md checklist holds.

## 5. Hand over

Reply with the link, one line per part of the page, the claims you labelled unverified, and a note that the page is private until shared from its Share menu. If the research turned up a mistake in something the user already has (a spec, a note, a plan), name it.
