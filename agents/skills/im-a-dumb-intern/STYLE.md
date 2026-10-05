# Explainer style

The house style of the user's explainer pages. [template.html](template.html) is the source of truth for CSS, tokens and components. This file covers voice, structure and the checks.

Exemplars, readable with Artifact `read` when you want to see a pattern in full:

- **The Watermark Cache** (`https://claude.ai/artifact/JxjJx2nUU3wRChRFQKtRTA`): a concept deep-dive. What a cache is, then this repo's cache, a code walkthrough, and the gap in the new adapter. Has a sticky contents rail.
- **DSP Reporting Map** (`https://claude.ai/artifact/AvpmGFS1w9BCgM3uB4cYY4`): an architecture map. A layer diagram as the spine, colour-keyed cards per layer, one request traced step by step.
- **ClickHouse Switch Plan** (`https://claude.ai/artifact/WVuS7Rp5Qgy5PeyxPkgZxP`): a change plan. A before/after diagram with a path toggle, a file-by-file status table, and options compared.
- **Time Zone Parity** (`https://claude.ai/artifact/Ts766bMRW2XuVnjbhSMpSi`): a three-part arc of today, the problem and the fix, ending with the proof.

## Voice

- Define every term where it first appears, in plain words, then give the name engineers use for it so the reader can search it: "a lock only one goroutine can hold at a time. This is called a **mutex**." Use that one name from then on.
- Give each abstract concept one **analogy** box from everyday life (a whiteboard, a phone book, a railway clock). A concrete concept goes straight to the example.
- Use this repo's real names, `file:line` references and values from your own checks. Mark made-up example values as examples.
- Write short sentences in the active voice. A figure caption states the figure's takeaway.
- Label an unverified claim right where it appears.

## Structure

- **Hero**: an eyebrow in mono (`backend/dsp · reporting`), the page name as `h1`, a lede saying what the page covers and why it matters to the reader's task, then the "You'll learn" box.
- **Arc**: the general concept, how it works here, what's wrong or changing, how to change it. When the page has a today / problem / fix arc, group sections into parts: one colour per part, a `.part-head` banner, and `.parts` cards in the hero linking to each part.
- **Sections** are numbered. Use the sticky contents rail when there are more than 7 sections; below that, delete the `nav.toc` and the `.wrap` grid becomes one column.
- **Each section** has prose, then at most one diagram or table, then its caption.
- **Reading the code**: the one function that matters, with numbered `.mark`s in the code matched by a `.steps` list.
- **For a change**: a file-by-file table with pills (`new`, `edit`, `gone`, `same`), then open questions and decisions as `.cards`.
- **Glossary** last (`dl.gloss`), holding every jargon-list term. The **footer** lists sources (files, docs, commits, checks) and links to related explainers.

## Colour

Colour marks a role. Pick 2–4 roles for the page (the systems being compared, states like hit and miss, the layers), give each a hue from the template palette, and keep it the same in prose, tables, diagrams and part banners. Write the mapping in the layout comment at the top of the `<style>`. Red means wrong or broken, and nothing else.

## Diagrams

The `artifact-diagramming` skill's rules apply. On top of them:

- Use the template's SVG classes. They read the colour tokens, so both themes work without edits.
- Each line's arrowhead uses the marker of the same colour (`#ah`, `#ah-blue`, `#ah-amber`, `#ah-green`, `#ah-violet`, `#ah-red`).
- Keep every label inside the `viewBox` and clear of lines and other labels. Size boxes from their longest label: about 7px per character at 12px, about 8px at 14px bold.
- The `.fig-box` scrolls sideways on a phone, so an SVG can keep its `min-width`.

## Checklist

Done when all of these hold:

- Every jargon-list term is defined where it first appears and is in the glossary.
- Every section's takeaway is in its first sentence or its caption.
- Every claim traces to code, a doc or a check, and the unverified ones are labelled.
- Every colour comes from a token, so dark mode works with no extra rules.
- Nothing is wider than a phone screen outside `.fig-box`, `.table-scroll` and `pre`.
- The title is a 2–4 word name, and the footer links the related explainers.
