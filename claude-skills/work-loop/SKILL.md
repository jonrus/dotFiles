---
name: work-loop
description: Run a spec's task file hands-off — spawn a fresh subagent per step (each following /work-task), verify each result from git, and continue until an unhappy path, a user-action step, or a push/PR step. Use only when explicitly invoked.
disable-model-invocation: true
---

# Work Loop

An orchestrator for `/work-task`. You (the main session) never implement steps yourself.
For each unchecked step you spawn a **fresh subagent** that executes exactly that one
step per `work-task/SKILL.md`, then you verify the result from git and move on. Each
subagent starts cold — only the spec, the task file and the codebase — which is the same
guarantee a manual fresh `/work-task` session gives. Your own context stays small because
only short reports come back.

Follow the project's `CLAUDE.md` for commits, pushing, and how to run commands; it wins on
conflicts with this file.

## Steps

1. **Find the task file** the same way `/work-task` does (given name/path, else the only
   file in `docs/specs/tasks/`, else ask). Read it and its spec.
2. **Preflight.** Run `git status --short` and check the current branch.
   - Dirty tree: stop and ask. A step's commit must contain only that step's work.
   - Wrong branch (e.g. `main` when `CLAUDE.md` says work happens on a spec branch): stop
     and ask.
3. **Loop.** Repeat until a stop condition fires:
   1. Re-read the task file and find the first unchecked step. None left: go to step 5.
   2. **Check the step for a stop condition before spawning anything.** Stop and hand
      over to the user if the step:
      - is tagged `[user]` — it needs a human (live browser check, interactive TTY
        command, credentials, a decision). Tell the user exactly what to do and wait;
      - is tagged `[push]`, or otherwise involves pushing or opening a PR — see step 4;
      - is untagged but its text clearly needs a human or a push. When unsure, stop and
        ask rather than guess.
   3. **Spawn one fresh subagent** (general-purpose, not a fork) with a prompt that gives
      it: the repo path, the task file path, and the instruction to read and follow
      `~/.claude/skills/work-task/SKILL.md` for the first unchecked step only. Also tell
      it:
      - it cannot ask the user questions, so on any unhappy path it must stop, leave the
        tree as-is, and report;
      - never push, open a PR, or merge;
      - end with a report in exactly this form: `RESULT: DONE` or `RESULT: BLOCKED`,
        then the step number, the commit hash (if DONE), a 2–3 line summary, and for
        BLOCKED the failure and what it thinks is wrong, plus an optional `Note:` line
        for anything it noticed but didn't act on (e.g. the spec's scope no longer
        matches the tasks).
   4. **Verify from git, not from the report.** After it returns, confirm that: the step's
      box is now `- [x]`, `HEAD` moved by exactly one new commit, and `git status --short`
      is empty. If the report says DONE but any check fails, treat it as BLOCKED.
   5. Briefly tell the user which step finished (one line), then continue.
4. **Push / PR step.** Do not spawn for it yet. Tell the user the loop has reached it,
   summarize what's been done, and ask how they want it handled per `CLAUDE.md` (they push
   themselves, or you do, and whether to open the PR). Only after they answer, spawn a
   subagent for the step and include their answer in its prompt as the authorization;
   without it, the subagent must not push. Then stop.
5. **Finish.** Report: steps completed, commits made, final `git log --oneline` for the
   run, and the spec's current `status`. Also list every agent `Note:` collected along the
   way, so spec mismatches and similar observations reach the user instead of being lost.

## Unhappy path

On BLOCKED (or a failed git verification), stop the loop immediately. Don't retry
automatically and don't spawn another agent. Show the user the step, the agent's report,
`git status --short` and the diff of any uncommitted partial work. Then work it out with
them. Typical outcomes:

- Amend the spec and/or task file (with the user's agreement), **commit the amendment on
  its own** so the tree is clean, then spawn a fresh agent to continue. Otherwise the next
  step's commit would sweep the amendment in and the preflight-style git check would fail.
- `git restore` the partial work, amend, and respawn.
- Resume the same agent with `SendMessage` if its debugging context is worth keeping. A
  fresh agent is better if it seems to have misread the spec.

The loop only restarts when the user says so (re-invoke `/work-loop`).
