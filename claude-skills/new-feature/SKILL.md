---
name: new-feature
description: Refine a user-authored feature draft (docs/features/NNN-slug.md) into a fully-scoped problem statement, ready for /new-spec — researches the current codebase to surface real ambiguities and edge cases, asks batched questions with recommended defaults, pushes back on scope creep, and records resolved decisions directly in the feature file. Use only when explicitly invoked.
disable-model-invocation: true
---

# New Feature

Sits between a user-authored feature draft and `/new-spec`. It does the scoping work that
benefits from investigating the codebase first, and writes the outcome into the feature
file so it survives interrupted sessions and machine switches. `/new-spec` then starts from
an already-resolved problem statement.

Follow the project's `CLAUDE.md` for branch creation, slug conventions (including checking
the slug isn't already in use by another branch, spec or feature file), committing, and how
to run commands. Where `CLAUDE.md` conflicts with this file on those points, `CLAUDE.md`
wins.

## Critical constraint: never write the spec

This skill edits the **feature file** (`docs/features/NNN-slug.md`) — never anything under
`docs/specs/`. Once scope is settled, set the feature file's `status` to `refined`, tell
the user it's ready, and stop. `/new-spec` writes the spec.

Feature status lifecycle: `draft` → `refined` (this skill) → `promoted` (set by
`/new-spec`).

## Steps

1. **Find the feature file.**
   - Given a path: use it. If its `status` is `refined` or `promoted`, stop and ask what
     the user wants (re-open refinement, or go to `/new-spec`) rather than re-running.
   - Otherwise look in `docs/features/` for `status: draft` files, excluding
     `000-feature_template.md` (never a real feature). One match: use it. Several: ask
     which.
   - None, and no other context: tell the user to copy the template to
     `docs/features/NNN-slug.md` (next number after the highest existing one) and fill in
     what they can, then re-run. Don't invent the initial draft — the user frames the ask
     first.
   - None, but the user hands off substantial conversation ("let's `/new-feature` this
     with what we've discussed"): that conversation is the user framing the ask. Create
     the file yourself from the template, transcribing only what was actually established.
     Never invent scope that wasn't said.

2. **Read the feature file in full**, including `Related Specs / Code` pointers and any
   `Open Questions`. They're a head start, not a substitute for step 3.

3. **Research before asking anything.** For each piece of the ask, read the actual code,
   schema, routes/views, and any existing specs or product doc it touches. For research
   spanning many files, prefer a background agent. Come away knowing the current data
   model, the query/view shapes already in place, and what existing capability the ask
   could reuse versus what it would have to build. This is what turns "what should the
   badge say?" into "the Queue view already merges unwatched+watching — should the badge
   match that, or count only unwatched?"

4. **Ask only genuine ambiguities, batched, with a recommended default.** Use
   `AskUserQuestion` (max 4 questions per call). Each question must:
   - Cite the specific file or behavior from step 3 that creates the fork.
   - Include a `(Recommended)` option with a one-line reason, so the user can accept the
     whole batch quickly or stop to think about one question.
   - Not repeat anything the feature file already answers, and never be a generic "any
     edge cases?" open-ender.

5. **Update the feature file after every round.** As soon as a batch is answered:
   - Append each resolved item to `Resolved Decisions` — the decision *and* a one-line why.
     Add the heading if it doesn't exist yet (the template omits it).
   - Remove or check off the matching `Open Questions`.

   This keeps the file resumable if the session ends mid-refinement.

6. **Handle scope changes explicitly — yours and theirs.**
   - *User proposes an addition.* Check what it would take, and say so. A small extension
     that cleanly reuses something existing can be absorbed into the scope sections.
     Anything needing real new capability, especially with its own ambiguities, should be
     flagged as a candidate for a *separate* feature file and added to `Explicitly Out of
     Scope`. Don't silently fold it in or silently reject it.
   - *User answers a question with a counter-question or a new constraint* (e.g. a
     deployment topology you hadn't scoped for, or "make sure this supports N of these,
     not just one"). Don't force an answer to the original framing. Pause, research the
     new input, record what it changes in `Related Specs / Code` or `Resolved Decisions`,
     and re-ask a revised batch.

7. **Do an unprompted "what am I missing" pass** before declaring scope done. Re-read the
   resolved scope against your step 3 research, looking for interactions the questions
   didn't cover (e.g. an existing filter or parameter, an existing view's edge case).
   There may be more than one. If nothing turns up, say so briefly rather than inventing a
   question.

8. **Finalize.** When nothing is left to ask:
   - Summarize the feature file's state: Firm Scope, Nice-to-have, Explicitly Out, and the
     resolved decisions behind each in-scope item.
   - Set the frontmatter to `status: refined`.
   - Commit the feature file per the project's conventions.
   - Tell the user it's ready for `/new-spec docs/features/NNN-slug.md`, and stop.
