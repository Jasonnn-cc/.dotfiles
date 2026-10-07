---
name: intern-notes
description: Write ADHD-friendly Obsidian notes and flashcards that teach a topic you don't understand.
disable-model-invocation: true
argument-hint: "What should I explain? (a topic, issue, feature or concept)"
---

# Intern notes

The user is an intern who does not yet understand a topic in this conversation. Build them a set of **fragments** to learn from: short, linked Obsidian notes, each readable in one sitting and grounded in the real code. Then append **flashcards** they can review later.

The topic is `$ARGUMENTS`. If that is empty, the topic is whatever this session is working on; say it back in one line and carry on.

Read [STYLE.md](STYLE.md) before writing the first fragment. It holds the fragment anatomy, the note-set layout, the voice rules, the ADHD rules and the flashcard format.

## 1. Pin the question

Settle the one question the notes answer ("how do the four Postgres timeouts work, and why does every service need them?") and what the reader will do with the answer. Ask the user only when the topic could mean two different things.

Done when you can state the question and the reader's next task in one sentence each.

## 2. Ground it

Read the real thing: the code path end to end, the tests that pin its behaviour, the ADRs, plans and docs, and the commits that introduced it. Reuse what this session already established instead of re-deriving it. When a behaviour is cheap to observe (a query, a test run, a script, a throwaway container), observe it. Leave the repo's files unchanged.

Done when every claim the fragments will make traces to a `file:line`, a command output or a doc you read, and you have listed the claims you could not verify. Those get labelled in the notes.

## 3. Plan the fragments

Split the topic into fragments, one idea each, ordered so understanding builds. Plan the whole set before writing:

- **README** — the topic outline: what this is, a read-in-this-order table with per-note times, and a 10-minute path.
- **000 Start Here** — the map: the entire topic on one page, ending with what "done" looks like.
- **010 Glossary** — every term the reader will meet, including the ones that feel basic.
- **Core fragments** — the general concept, then how it works here, then what is wrong or changing, then how to change it.
- **080 Exercises** — one exercise per concept, answers collapsed.
- **090 Code Index** — exact `file:line` pointers, when the topic is grounded in code.

Keep to what the question from step 1 needs.

Done when every fragment serves that question, every jargon term has a home, and no fragment carries more than one idea.

## 4. Write the fragments

Create the topic folder `~/Obsidian/InternNotes/[Topic]/`, where `[Topic]` is a title-cased hyphenated slug (`DB-Timeout-Hardening`). Name each file `NNN Title.md`; `000 Start Here.md` is the map. Follow the fragment anatomy in [STYLE.md](STYLE.md).

When the folder already exists, update it rather than replace it: reread the current fragments, revise what has drifted, keep what is still true, and re-check every `file:line` against the working tree. Leave no stale claim standing, and name the changes in step 6.

Done when every fragment passes the style checklist: TL;DR first, reading time and prereqs at the top, a next link at the bottom, one idea, and no claim that fails to trace (step 2).

## 5. Append the flashcards

Append to `~/Obsidian/InternNotes/[Topic]/Flashcards.md`, creating it when absent. Follow the flashcard format in [STYLE.md](STYLE.md): the `#flashcards/<topic-slug>` tag, a link to the topic outline, then `question` / `?` / `answer` cards.

Each core fragment contributes 3–7 cards; card the facts an engineer would be expected to explain, and skip the trivia. Cards carry general knowledge, not this codebase's decisions: set up a situation and ask for the approach, rather than asking what this repo does. See [STYLE.md](STYLE.md).

Done when each core fragment has its 3–7 cards, every card poses a general situation rather than a repo-specific choice, each answer stands alone, and the file still parses as spaced-repetition cards.

## 6. Hand over

Reply with the folder path, the reading order and its total time, the 10-minute path, a note that the flashcards are ready to review, and the claims you labelled unverified. When you updated an existing set, name what changed.
