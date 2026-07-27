---
name: new-feature
description: Refine a user-authored feature draft (docs/features/NNN-slug.md) into a fully-scoped problem statement, ready for /new-spec — researches the current codebase to surface real ambiguities and edge cases, asks batched questions with recommended defaults, pushes back on scope creep, and records resolved decisions directly in the feature file. Use only when explicitly invoked.
disable-model-invocation: true
---

# New Feature

Sits between a user-authored feature draft and `/new-spec`. `/new-spec` already does its
own scoping conversation (its step 2: "push back like a lightweight red-team pass"), but
that pass works from what the user says out loud in that session — it doesn't independently
investigate the codebase first, and nothing survives if the conversation gets interrupted.
This skill exists for asks complex enough that a chunk of that scoping should happen
*before* `/new-spec`, grounded in the actual implementation surface, with the outcome
written durably into the feature file itself — not just chat history — so `/new-spec`
starts from an already-resolved problem statement and the refinement work survives across
sessions/machines the same way a spec-tasks checklist does.

## Critical constraint: never write the spec

This skill edits the **feature file** (`docs/features/NNN-slug.md`) — never anything under
`docs/specs/`. Once scope is genuinely settled, flip the feature file's `status` to
`refined`, tell the user it's ready, and stop. Let `/new-spec` do the actual spec writing
(and its own red-team pass) from that resolved starting point.

## Steps

1. **Find the feature file.** If given a path, use it. Otherwise look in `docs/features/`
   for files with `status: draft` (excluding `000-feature_template.md`, which is never a
   real feature) — if there's exactly one, use it; if several, ask which one. If none
   exist, tell the user to copy `docs/features/000-feature_template.md` to
   `docs/features/NNN-slug.md` (next number after the highest existing one) and fill in
   what they can before running this skill — don't fabricate the initial draft yourself;
   the whole point is that the user frames the ask first.

2. **Read the feature file in full**, including any `Related Specs / Code` pointers and
   existing `Open Questions` it already lists — those are a head start, not a substitute
   for your own research in the next step.

3. **Research before asking anything.** For each piece of the ask, find and read the actual
   code, schema, routes/views, and any existing specs / the product doc it would touch.
   Prefer a background research agent for this when it spans multiple files — the goal is
   to walk away knowing the current data model, the exact query/view shapes already in
   place, and any existing capability the ask could reuse vs. would need to newly build.
   This is what turns "what do you want the badge to say" into "the Queue view already
   merges unwatched+watching — should the badge count match that, or literally just
   unwatched?" — a question the user can answer in five seconds because it's concrete, not
   one that makes them re-derive the ambiguity themselves.

4. **Ask only genuine ambiguities, batched, with a recommended default.** Use
   `AskUserQuestion` (max 4 per call). For each question:
   - Ground it in something specific found in step 3 — cite the file/behavior that creates
     the ambiguity, briefly, so the user sees *why* it's a real fork, not a rubber-stamp.
   - Give a `(Recommended)` option with a one-line reason, so a user who trusts your
     judgment can blow through the whole batch by picking the recommended option every
     time, and a user who wants to think about one specific question still can.
   - Don't ask questions the feature file already answers, and don't ask generic "any edge
     cases?" open-enders — every question should be answerable in one click because the
     legwork to make it concrete already happened.

5. **Update the feature file after every round — don't wait until the end.** As soon as a
   batch of questions is answered, edit the file immediately: append each resolved item to
   `Resolved Decisions` (the decision *and* the one-line why, not just the conclusion), and
   remove or check off the corresponding entries from `Open Questions` (add a
   `Resolved Decisions` heading if the file doesn't have one yet — the template omits it
   until refinement starts). This is what makes the file resumable if the session ends
   mid-refinement, the same way `/work-task` checks off one step before stopping rather
   than batching updates to the end.

6. **Watch for scope creep — yours and theirs.** If the user proposes adding something
   mid-conversation, don't silently fold it in or silently reject it: check what it would
   actually take (does it reuse an existing capability, or does it need new backend/data
   work of its own?) and say so. Small, cleanly-additive extensions that reuse something
   that already works are fine to absorb into the feature file's scope sections. Anything
   that would require real new capability — especially anything with its own ambiguities —
   is a candidate to flag for a *separate* future feature file instead; say that explicitly
   and add it to the current file's `Explicitly Out of Scope` section rather than letting
   scope quietly grow.

7. **Do at least one unprompted "what am I missing" pass yourself** before declaring the
   scope done — don't wait for the user to ask "any concerns?". Re-read the resolved scope
   against the research from step 3, looking for one more real interaction the questions so
   far didn't cover (e.g. how a new feature interacts with an existing filter/parameter, or
   an existing view's edge case). If nothing turns up, say so briefly rather than padding
   with a question for its own sake.

8. **Finalize.** Once there's nothing left to ask, give a complete summary of the feature
   file's current state (Firm Scope, Nice-to-have, Explicitly Out, and the resolved
   decisions behind each in-scope item), flip the frontmatter to `status: refined`, and
   tell the user it's ready for `/new-spec docs/features/NNN-slug.md`. Don't proceed into
   `/new-spec`'s own steps yourself.
