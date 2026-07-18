---
name: spec-tasks
description: Generate a task checklist file from an approved spec, to be executed one step per session via /work-task. Use only when explicitly invoked.
disable-model-invocation: true
---

# Spec → Tasks

Turns a spec at `docs/specs/<name>.md` into an execution checklist at
`docs/specs/tasks/<name>.md`. The task file **is version-controlled** while its spec is
`in-progress` (confirm `docs/specs/tasks/` is *not* gitignored; remove any blanket ignore
entry for it if one exists) — committing it is what makes it possible to resume work from
a different machine, not just a different session. It's still a disposable document in the
long run: `/work-task` deletes it once the spec reaches `implemented` (leaving the commit
of that deletion to the user), at which point the spec is the durable record, not the
checklist.

## Critical constraint: each step must be independently executable

Every checked-off step will be picked up by `/work-task` in a **brand-new session with no
memory of this conversation** — only the spec, the task file, and the codebase as it exists
at that time. A step like "wire up the rest of the API" is not usable. Each step must name
concrete files/functions/endpoints to touch and state a concrete "done when" condition, so
a cold session can execute it correctly without needing to ask anything first.

## Steps

1. Read the target spec in full (ask which one if not obvious/given). If its `status` is
   still `draft`, stop and confirm with the user that it's ready to move forward — don't
   silently promote a draft.
2. Read the current state of the relevant code so steps reference what's actually there,
   not stale assumptions from when the spec was written.
3. Break the spec's Design/Scope into an ordered sequence of small, concrete,
   independently-executable steps. Order for dependencies (e.g. schema before routes
   before UI).
4. Write `docs/specs/tasks/<name>.md`:

   ```markdown
   # Tasks: <spec title>
   Spec: docs/specs/<name>.md
   Generated: <YYYY-MM-DD>

   - [ ] 1. <Concrete step> — done when: <concrete acceptance condition>
   - [ ] 2. ...
   ```

5. Update the spec's frontmatter to `status: in-progress`.
6. Tell the user the task file is ready and that each `- [ ]` item is meant to be run via
   `/work-task` in its own fresh session.

If a task file for this spec already exists and has any `- [x]` items checked, do not
silently overwrite it — show the user what's already done and ask whether to regenerate
(losing progress markers) or amend it in place.
