---
name: work-task
description: Resume a task file, execute only the next unchecked step, check it off, and stop. Use only when explicitly invoked, typically as the first thing in a fresh session.
disable-model-invocation: true
---

# Work Task

Executes exactly **one** step from a `docs/specs/tasks/<name>.md` file, then stops — by
design, so each step gets a clean session per this project's Spec-Driven Development
workflow. Do not continue on to the next unchecked step in the same session even if it
looks quick.

## Steps

1. **Find the task file.** If given a name/path, use it. Otherwise look in
   `docs/specs/tasks/` — if there's exactly one file, use it; if there are several, ask
   which one.
2. **Read the spec too** (its path is noted at the top of the task file) — the task file is
   a checklist, the spec is where the why/design detail lives; don't execute a step you
   don't understand the reasoning for.
3. **Find the first unchecked (`- [ ]`) step.** State it back in one sentence before
   starting, so the user can redirect if it's not what they expected.
4. **Execute only that step** — read the relevant code first, make the change, and verify
   it (run tests/typecheck/the app as appropriate — don't just claim success).
5. **If the step resolved or confirmed something the spec left open** (an Open Questions
   entry, an unverified assumption, a "verify at implementation time" note), update the
   spec to record that — following the existing pattern in the spec of a strike-through/
   confirmation note near the relevant Design section plus a matching update in Open
   Questions. Do this before checking off the task step.
6. **Check it off** (`- [ ]` → `- [x]`) in the task file once verified.
7. **If that was the last step:** set the spec's frontmatter to `status: implemented`. Keep
   the task file — it stays in `docs/specs/tasks/` as a record even after completion (it
   can be useful source material for documentation later). Tell the user the spec is fully
   implemented and ready to be committed along with the rest of the changes.
8. **Stop.** Summarize what changed and note that the next step is ready to be picked up in
   a fresh session — don't proceed further in this one.
