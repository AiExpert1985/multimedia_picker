---
description: Archive current task state and clean workspace
---

**CURRENT STATE: TASK ABORT**

Archive current task state and clean workspace.

---

## 1. Input

`/abort [reason]`

- If `reason` provided → **Aborted By:** SYSTEM, **Reason:** [reason]
- If no `reason` → **Aborted By:** USER, **Reason:** "User requested"

---

## 2. Preflight

Check `/obelisk/temp-state/`.

**If empty:**
> "⚠️ No active task. Workspace is clean." → STOP

**If files exist:**

1. **Detect phase** from files present:
   - Only `task.md` → Phase: PLANNING
   - `task.md` + `plan.md` → Phase: IMPLEMENTATION  
   - `task.md` + `plan.md` + `implementation-notes.md` → Phase: REVIEW
   - No `task.md` → Phase: DISCOVERY

2. **Extract task name:**
   - From `task.md` header if present
   - Else → `draft-context`

3. **Set archive path:**  
   `/obelisk/tasks/aborted/YYYYMMDD-[task-name]/`

---

## 3. Archive

1. Create archive directory

2. Move ALL files from `/obelisk/temp-state/` into archive

3. Create `abort-summary.md` in archive:

```markdown
**Date:** [YYYY-MM-DD HH:MM]
**Phase:** [DISCOVERY | PLANNING | IMPLEMENTATION | REVIEW]
**Aborted By:** [USER | SYSTEM]
**Reason:** [One sentence]
```

---

## 4. Output

```
🛑 TASK ABORTED

Archived: /obelisk/tasks/aborted/YYYYMMDD-[task-name]/
Phase: [Phase]
Reason: [Reason]

System ready for next task.
```

STOP.