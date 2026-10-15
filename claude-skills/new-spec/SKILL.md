---
name: new-spec
description: Start a new Spec-Driven Development spec for a scoped piece of work — interviews the user, writes docs/specs/<name>.md with status frontmatter, and cross-references the project's product doc. Use only when explicitly invoked.
disable-model-invocation: true
---

# New Spec

Follow this project's Spec-Driven Development pattern: `docs/specs/*.md` are the committed,
versioned single source of truth for a scoped piece of work. This skill only writes the
**spec**. Task breakdown is `/spec-tasks` and per-step execution is `/work-task`; don't
skip ahead to tasks or code here.

Follow the project's `CLAUDE.md` for branch creation, slug conventions (including checking
the slug isn't already in use), numbering, committing, and how to run commands. Where
`CLAUDE.md` conflicts with this file on those points, `CLAUDE.md` wins.

Spec status lifecycle: `draft` (this skill) → `in-progress` (set by `/spec-tasks`) →
`implemented` (set by `/work-task` on the last step). Don't set the latter two here.

## Optional input: a refined feature file

If the user points you at a `docs/features/NNN-slug.md` (normally one `/new-feature` has
marked `status: refined`), read it in full. Use its `Firm Scope`, `Nice-to-have Scope`,
`Explicitly Out of Scope` and `Resolved Decisions` as the starting point for step 2 instead
of interviewing from scratch. That conversation already happened; don't re-derive it.
Confirm it still holds against the current codebase and fill any gaps.

Check its `status` first. `refined` is the expected value. If it's `draft`, the scoping
wasn't finished: tell the user and suggest `/new-feature` first, unless they want to
proceed anyway. If it's `promoted`, a spec already exists (see `promoted_to`): stop and
ask rather than writing a second spec or overwriting that pointer.

If something in the feature file turns out wrong or incomplete, don't edit it to fix that.
The spec is the source of truth, so put the correction and its reasoning in the spec's
Design section, and raise it with the user like any other open question. Step 7 covers what
happens to the feature file afterwards.

With no feature file, interview the user directly. A feature file is never required.

## Steps

1. **Orient.** Check for `docs/specs/`. If it doesn't exist, this is the project's first
   spec: create it and confirm the naming convention below with the user rather than
   assuming. Read the existing files directly in `docs/specs/` (not `docs/specs/tasks/`) so
   you don't contradict or duplicate a prior decision. If a top-level product doc exists
   (e.g. `docs/app_idea.md`), read it fully; the spec must stay consistent with it.

2. **Scope the conversation, don't just transcribe it.** Ask what problem or feature this
   spec covers (or start from the feature file). Push back like a lightweight red-team
   pass: surface edge cases and interactions with existing specs and features. Write
   nothing down until the what, why and how are settled — a spec transcribed from a vague
   ask is worse than none.

3. **Name the file.** `docs/specs/NNN-kebab-case-title.md`, where `NNN` is zero-padded and
   one higher than the highest existing spec (`001` if none). It's independent of any
   source feature file's number — `docs/features/` and `docs/specs/` are numbered
   separately. From a feature file, reuse its slug for the title; otherwise confirm the
   title with the user if it isn't obvious.

4. **Write the spec** with this frontmatter and shape:

   ```markdown
   ---
   status: draft
   created: <YYYY-MM-DD>
   ---

   # <Title>

   ## Context
   Why this work is happening, what prompted it, and a link/reference to the relevant part
   of the product doc if applicable.

   ## Scope
   What's in. What's explicitly out (and deferred to a future spec).

   ## Design
   The what/how — decisions made, the approach chosen, and *why* (not just the conclusion —
   the reasoning, so a future session doesn't have to re-derive it).

   ## Open Questions
   Anything genuinely unresolved, or "None" once settled.
   ```

5. **Cross-reference the product doc, don't duplicate into it.** If this spec refines or
   supersedes something in the top-level product doc, make a small targeted edit there — a
   sentence or inline pointer like `(refined in docs/specs/003-ignore-rules-v2.md)` —
   rather than rewriting its content. The product doc stays stable; specs hold the detail
   and iteration.

6. **Red-team the draft before finalizing.** Your own reasoning has blind spots, so review
   with fresh eyes: prefer an independent pass with no memory of the drafting conversation
   (e.g. a subagent) over reviewing it yourself.
   - Run at least one pass. Run another if a pass finds anything substantive.
   - A pass that finds nothing is a good stopping signal. A second pass that catches a
     real bug the first missed (including one in the first pass's own fixes) means the
     risk was real, so keep going.
   - Once passes stop finding things, a narrower check scoped to the code touched by the
     latest round of fixes can replace a further full pass.
   - Fix every finding directly in the spec, and record a short retrospective in Open
     Questions — what each pass caught and how it was fixed — so a future reader doesn't
     have to reconstruct the history from git log.

7. **If the spec came from a feature file**, update that file's frontmatter to
   `status: promoted` and add `promoted_to: docs/specs/NNN-kebab-case-title.md`. Keep the
   feature file in the repo permanently as a record of how the ask was framed and refined.

   For any `Resolved Decisions` entry that was superseded or corrected while writing the
   spec (per the Optional input section), don't rewrite it. Append a short pointer beside
   it, e.g. "Superseded during spec writing — see docs/specs/NNN-slug.md's Design section
   for the corrected decision". This is the same append-don't-rewrite convention specs
   use for corrections found during implementation, and it stops a future reader trusting
   a stale claim in isolation.

8. **Commit and stop.** Commit the spec (and the updated feature file and product-doc
   pointer, if any) per the project's conventions. Don't generate a task file or write
   code; hand off to `/spec-tasks`.
