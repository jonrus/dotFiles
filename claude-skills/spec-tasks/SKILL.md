---
name: spec-tasks
description: Generate a task checklist file from an approved spec, to be executed one step per session via /work-task. Use only when explicitly invoked.
disable-model-invocation: true
---

# Spec → Tasks

Turns a spec at `docs/specs/<name>.md` into an execution checklist at
`docs/specs/tasks/<name>.md`. The task file is **version-controlled**, which is what lets
work resume from a different machine, not just a different session. It stays in the repo
permanently, even after the spec reaches `implemented`: the spec is the durable record of
*what* and *why*, and the task file records how the work was broken down and sequenced,
which is useful source material later (e.g. for documentation).

Follow the project's `CLAUDE.md` for how to run commands, committing, and anything it
requires in the final task steps (e.g. a standard set of verification commands, or opening
a PR). Where `CLAUDE.md` conflicts with this file on those points, `CLAUDE.md` wins.

## Critical constraint: each step must be independently executable

Every step will be picked up by `/work-task` in a **brand-new session with no memory of
this conversation** — only the spec, the task file, and the codebase as it then exists. A
step like "wire up the rest of the API" is not usable. Each step must name the concrete
files, functions or endpoints to touch and state a concrete "done when" condition, so a
cold session can execute it without asking anything first.

## Steps

1. **Check preconditions.**
   - Read the target spec in full (ask which one if not obvious or given).
   - Spec `status: draft`: stop and confirm with the user that it's ready. Don't silently
     promote a draft.
   - Spec `status: in-progress` or `implemented`: tasks were already generated or the work
     is done. Say so and ask what the user wants before going further.
   - A task file for this spec already exists with any `- [x]` items: don't overwrite it.
     Show what's done and ask whether to regenerate (losing progress markers) or amend in
     place.
   - Confirm `docs/specs/tasks/` is *not* gitignored; remove any blanket ignore entry for
     it if one exists.

2. **Read the current state of the relevant code**, so steps reference what's actually
   there rather than assumptions from when the spec was written.

3. **Break the spec's Design/Scope into an ordered sequence of small, concrete,
   independently-executable steps.** Order for dependencies (e.g. schema before routes
   before UI).

4. **Write `docs/specs/tasks/<name>.md`:**

   ```markdown
   # Tasks: <spec title>
   Spec: docs/specs/<name>.md
   Generated: <YYYY-MM-DD>

   - [ ] 1. <Concrete step> — done when: <concrete acceptance condition>
   - [ ] 2. ...
   ```

   Tag steps that an unattended run must not do on its own, right after the checkbox:
   - `[user]` — needs a human: a live browser check, a command needing an interactive TTY,
     credentials, or a judgment call. The step text must say exactly what the user does and
     what to look for, with full paths, URLs and exact commands rather than relative
     references.
   - `[push]` — pushes the branch or opens a PR (the project's `CLAUDE.md` may require
     confirmation first).

   Example: `- [ ] 9. [user] Check the badge in a browser — done when: ...`. Untagged steps
   are assumed safe for an agent to run start to finish. `/work-loop` stops at tagged
   steps.

5. **Review the written task file against the spec.** This checks the *decomposition*, a
   different failure mode from a spec-level red-team pass, which checks the *design*. Look
   for:
   - dropped details;
   - ordering or dependency mistakes — e.g. a step that wires something to a placeholder
     that a later step replaces. Reorder so the dependency is built first;
   - steps too vague for a cold `/work-task` session to execute without asking a question.

   Fix decomposition issues directly in the task file.

   If the pass exposes a gap in the *spec's own content* — e.g. a Design-section fix with
   no matching Testing requirement, or a Scope item the Design never addresses — fold the
   fix back into the spec too, with a short retrospective note (same convention as a
   red-team pass). The task file is only a record of the breakdown; a content gap that
   lives only there is invisible to anyone reading the spec alone.

6. **Set the spec's frontmatter to `status: in-progress`**, then commit the task file and
   the spec change per the project's conventions, so the first `/work-task` session
   starts from a clean tree.

7. **Tell the user the task file is ready**, and that each `- [ ]` item is meant to be run
   via `/work-task` in its own fresh session.
