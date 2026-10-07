# Intern-note style

The house style for the fragments [SKILL.md](SKILL.md) writes. The exemplar is `~/Obsidian/InternNotes/DB-Timeout-Hardening/`: read its map and one core fragment when a pattern is not obvious.

## Fragment anatomy

A **fragment** is one idea, readable in one sitting. Every fragment is shaped the same way, so the reader always knows where they are:

```md
# NNN — Title

> **TL;DR** — the one takeaway, stated flat, in one to three sentences.

**Reading time:** ~N min · **Prereqs:** [[previous]] · **Next:** [[next]]

<the body: one idea, told as prose, then at most one table or diagram>

> **You can stop here.** Optional: what to read next if they want more.

<optional exercise: the question, then a collapsed answer>

> [!question]- Answer
> ...

Next up → [[next]]
```

Rules:

- The TL;DR is the takeaway, not a summary of the headings; a reader who reads only it still has the idea.
- Reading time is honest and small. Aim 3–8 minutes; split anything longer.
- Prereqs and Next are wikilinks, so the notes chain without the reader holding a map.
- The stop-marker is a real exit, not a formality; after it, at most an optional exercise.
- One idea per fragment. If you catch yourself writing "and also", it is two fragments.

## The note set

| File | Job |
|---|---|
| `README.md` | The topic outline: what this is, a read-in-this-order table with per-note times, how to use the notes, and a 10-minute path. |
| `000 Start Here.md` | The map: the whole topic on one page, ending with what "done" looks like. |
| `010 Glossary.md` | Every term the reader will meet, in plain English, grouped by area. |
| `020 …`, `030 …` | Core fragments, in the order understanding builds: the concept, how it works here, what is wrong or changing, how to change it. |
| `080 Exercises.md` | One exercise per concept; answers collapsed. |
| `090 Code Index.md` | Exact `file:line` pointers, verified against the working tree. |

Numbers leave gaps on purpose, so a fragment can be inserted without renumbering. The glossary is a low number so the reader can reach it from anywhere.

## Voice

- Define every term where it first appears, in plain words, then give the name engineers use so the reader can search it: "a claim on a row while you change it. This is called a **lock**." Use that name from then on.
- Give each abstract idea one analogy from everyday life (a phone line, a whiteboard, a railway clock). A concrete idea goes straight to the example.
- Use the repo's real names, `file:line` references and values from your own checks. Mark made-up example values as examples.
- Short sentences in the active voice. A table or figure states its takeaway in the sentence above it.
- Format for the eye: tables for comparisons, `> [!note]` / `> [!warning]` / `> [!caution]` for side facts, bold for a term's first use. A wall of prose is a bug.
- Label an unverified claim right where it appears.

## The ADHD rules

The reader loses the thread easily. Every choice above exists to keep the thread reachable:

- One idea per fragment; finish the thought before introducing the next.
- Always answer "how long, what do I need, where next" at the top of a fragment.
- Always give an exit: the stop-marker means a fragment can be left early without guilt.
- Never rely on the reader holding state from three fragments ago; link back instead.
- Collapse exercise answers behind `> [!question]-` so they can attempt before revealing.

## Flashcards

Append to `Flashcards.md` in the topic folder. One card per fact worth remembering; the front is a question, the back is one idea:

```md
#flashcards/<topic-slug>

[[README]]

Question
?
Answer

Question
?
Answer
```

- The tag is `#flashcards/<topic-slug>`, so the deck is scoped to this topic; the vault's spaced-repetition plugin reads `#flashcards` and its sub-tags.
- A lone `?` on its own line separates front from back. That is the multiline separator this vault is configured for.
- Link the topic outline (`[[README]]`) so a review session can jump back to the notes.
- The answer stands alone: no "see above", no pronoun that needs the question.
- Each core fragment contributes 3–7 cards. Skip trivia; card the things an engineer would be expected to explain.

Cards carry **general knowledge**, not this codebase's decisions. A card that asks "what lock timeout does the chatbot use?" rots the moment the config changes and tests recall, not understanding. A card that sets up the situation and asks for the approach tests the reasoning and stays true in any codebase:

- **Front:** In a service where many requests share a small pool of DB connections, and a stuck lock wait holds a slot for as long as it runs, which timeout bounds the wait?
- **Back:** `lock_timeout`; it fails the wait fast so the connection returns to the pool.

Every card supplies its own context: "in an environment where Z, which approach should be used?" The answer is the approach or the principle, never "this repo does X".
