
---

**CURRENT STATE: TASK ABORT**

Archive current progress and clean workspace.

---

## Inputs

- **Aborted at:** [phase]
- **Reason:** [blocker or "User requested"]

---

## Steps

1. Create `/obelisk/tasks/aborted/YYYYMMDD-short-task-name/`

2. Copy from `/obelisk/temp-state/` (if exist):
   - `task.md`
   - `plan.md`
   - `implementation-notes.md`

3. Create `abort-reason.md`:
```markdown
   **Aborted at:** [Phase]
   **Reason:** [Description]
```

4. Clean `/obelisk/temp-state/`

---

## Output

> "TASK ABORTED — Saved to `/obelisk/tasks/aborted/[folder]`
> 
> System ready for next task."