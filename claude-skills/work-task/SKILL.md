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

Follow the project's `CLAUDE.md` for how to run commands, commit, and push, and for any
step-specific exceptions to the order below (e.g. a final PR step that is checked off
before the push rather than after). Where `CLAUDE.md` conflicts with this file on those
points, `CLAUDE.md` wins.

## Steps

1. **Find the task file.** If given a name/path, use it. Otherwise look in
   `docs/specs/tasks/` — if there's exactly one file, use it; if there are several, ask
   which one.
2. **Read the spec too** (its path is noted at the top of the task file) — the task file is
   a checklist, the spec is where the why/design detail lives; don't execute a step you
   don't understand the reasoning for.
3. **Find the first unchecked (`- [ ]`) step.** State it back in one sentence before
   starting, so the user can redirect if it's not what they expected.

   If every step is already checked, a previous session was interrupted after the last
   check-off. Don't execute anything. Verify the spec's work is actually complete, then
   set the spec's `status: implemented` if it isn't already, commit that change, and tell
   the user.
4. **Execute only that step** — read the relevant code first, make the change, and verify
   it (run tests/typecheck/the app as appropriate — don't just claim success).
5. **If the step resolved or confirmed something the spec left open** (an Open Questions
   entry, an unverified assumption, a "verify at implementation time" note), update the
   spec to record that — following the existing pattern in the spec of a strike-through/
   confirmation note near the relevant Design section plus a matching update in Open
   Questions. Do this before checking off the task step.
6. **Check it off and commit.** Once the step is verified:
   - Change `- [ ]` → `- [x]` in the task file.
   - If that was the **last** step, also set the spec's frontmatter to
     `status: implemented`. Keep the task file in `docs/specs/tasks/` as a record.
   - Commit everything from this step (code, task file, and any spec changes) in one
     commit, per the project's conventions, so the tree is clean afterwards.
7. **Stop.** Summarize what changed. If the spec is now fully implemented, say so;
   otherwise say the next step is ready to be picked up in a fresh session. Handle any
   push exactly as `CLAUDE.md` directs (if it says to ask first, ask) — don't proceed
   further in this session.

## When the step doesn't go to plan

Never check off a step that isn't verified done, and never commit unverified work. If
something goes wrong, stop and tell the user rather than improvising past it:

- **Verification fails and you can't fix it within the step's scope.** Leave the box
  unchecked, report what failed and why, and let the user decide. Don't weaken the "done
  when" condition to make it pass. Leave the partial work uncommitted and say so.
- **The step is wrong or infeasible** (it references code that no longer exists, conflicts
  with the spec, or rests on an assumption that turned out false). Don't silently rewrite
  it. Explain the problem and propose a fix to the task file and, if the spec itself is
  affected, to the spec — then apply it only once the user agrees.
- **The step is too big for one session.** Do the part that can be verified on its own,
  split the step in the task file into checked and unchecked sub-steps, commit the verified
  part, and stop. Don't check off the whole thing.
- **The work turned up a problem outside this step's scope.** Note it in the spec's Open
  Questions (or tell the user) rather than fixing it here.
