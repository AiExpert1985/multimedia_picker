---
description: Abort & document current task
---

**CURRENT STATE: TASK ABORT**

Archive current task state and reset the system to a clean state.

---

## 1. Command

`/abort-task [reason]`

- If `reason` provided → use as **Reason**
- If omitted → **Reason:** "User requested"

**Note:**  
Who initiated the abort (USER or SYSTEM) is inferred from context and recorded.

---

## 2. Preflight

Check `/obelisk/temp-state/`.

- **If empty:**  
  > "⚠️ No active task. Workspace is clean." → STOP

- **If files exist:**

### Detect Phase (from files present)

- No `task.md` → **DISCOVERY**
- `task.md` only → **TASK DEFINED**
- `task.md` + `plan.md` → **IMPLEMENTATION**
- `task.md` + `plan.md` + `implementation-notes.md` → **REVIEW**

### Task Name
- From `task.md` header if present  
- Else → `draft-context`

### Archive Path
`/obelisk/tasks/aborted/YYYYMMDD-[task-name]/`

---

## 3. Archive & Reset

1. Create archive directory
2. **MOVE ALL files** from `/obelisk/temp-state/` into archive
3. Create `abort-summary.md`:

```markdown
**Date:** [YYYY-MM-DD HH:MM]
**Phase:** [Detected Phase]
**Aborted By:** [USER | SYSTEM]
**Reason:** [One sentence]
```

---

## 4. Update Project History

If task.md existed, append to `/obelisk/tasks/project-history.md`:
```markdown
## YYYY-MM-DD | [task-name] | ABORTED
Goal: [One-line goal from task.md, or "Task undefined"]
Reason: [Abort reason from step 1]
```

Create file with header `# Project History` if it doesn't exist.

Skip if no task.md existed (nothing meaningful to log).

---

## 5. Output

```
🛑 TASK ABORTED

Archived: /obelisk/tasks/aborted/YYYYMMDD-[task-name]/
Phase: [Phase]
Reason: [Reason]

System ready for next task.
```

STOP.