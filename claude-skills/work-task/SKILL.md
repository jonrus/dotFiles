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
5. **Check it off** (`- [ ]` → `- [x]`) in the task file once verified.
6. **If that was the last step:** set the spec's frontmatter to `status: implemented` and
   delete the task file (it's version-controlled while `in-progress` specifically so work
   can resume across machines — once implemented, the spec is the durable record and the
   checklist has served its purpose). Tell the user it's gone and ready to be committed
   along with the rest of the changes — don't commit it yourself, that's still their call.
7. **Stop.** Summarize what changed and note that the next step is ready to be picked up in
   a fresh session — don't proceed further in this one.
