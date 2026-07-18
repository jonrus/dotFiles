---
name: new-spec
description: Start a new Spec-Driven Development spec for a scoped piece of work — interviews the user, writes docs/specs/<name>.md with status frontmatter, and cross-references the project's product doc. Use only when explicitly invoked.
disable-model-invocation: true
---

# New Spec

Follow this project's Spec-Driven Development pattern: `docs/specs/*.md` are the committed,
versioned single source of truth for a scoped piece of work. This skill only writes the
**spec** — task breakdown is a separate step (`/spec-tasks`), and per-step execution is
another (`/work-task`). Do not skip ahead to tasks or code in this skill.

## Steps

1. **Orient.** Check for `docs/specs/` — if it doesn't exist yet, this is the first spec in
   the project; create the directory and confirm the naming convention below with the user
   rather than assuming. Read any existing files directly in `docs/specs/` (not
   `docs/specs/tasks/`) to avoid contradicting or duplicating a prior decision. If a
   top-level product doc exists (e.g. `docs/app_idea.md`), read it fully — it's the
   higher-level source of truth this spec must stay consistent with.

2. **Scope the conversation, don't just transcribe it.** Ask the user what problem or
   feature this spec covers. Push back like a lightweight red-team pass: surface edge
   cases, ask about interactions with existing specs/features, and don't write anything
   down until the what/why/how are actually settled — a spec transcribed from a vague ask
   is worse than no spec at all.

3. **Name the file.** Convention: `docs/specs/NNN-kebab-case-title.md`, where `NNN` is a
   zero-padded sequence number one higher than the highest existing spec (start at `001`
   if none exist). Confirm the title with the user if it isn't obvious from the
   conversation.

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

   `status` starts as `draft`. It becomes `in-progress` when `/spec-tasks` generates a task
   file, and `implemented` when `/work-task` finishes the last step — don't set those
   yourself in this skill.

5. **Cross-reference the product doc, don't duplicate into it.** If this spec refines or
   supersedes something stated in the top-level product doc (e.g. `docs/app_idea.md`), make
   a small targeted edit there — a sentence or inline pointer like
   `(refined in docs/specs/003-ignore-rules-v2.md)` — rather than rewriting that doc's
   content. The product doc should stay stable and rarely change; specs are where detail
   and iteration live.

6. **Stop here.** Don't generate a task file and don't start writing code — hand off to
   `/spec-tasks` for that.
