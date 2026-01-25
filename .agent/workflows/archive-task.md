---
description: Archive task & clean workspace
---

**CURRENT STATE: TASK ARCHIVE**

Archive task materials and clean workspace.

---

## 1. Read Status

Read `/obelisk/temp-state/review-notes.md`.

- **If missing:** → "❌ ARCHIVE BLOCKED — No review-notes.md found" → STOP
- **Extract status:** APPROVED or CHANGES REQUIRED

---

## 2. Determine Destination

| Status | Archive Path |
|--------|--------------|
| APPROVED | `/obelisk/tasks/completed/YYYYMMDD-[task-name]/` |
| CHANGES REQUIRED | `/obelisk/tasks/rejected/YYYYMMDD-[task-name]/` |

Extract `[task-name]` from task.md header.

---

## 3. Archive

1. Create destination directory

2. Move ALL files from `/obelisk/temp-state/` to archive:
   - `task.md`
   - `plan.md`
   - `implementation-notes.md`
   - `review-notes.md`

3. Verify `/obelisk/temp-state/` is empty

- **If not empty:** → "❌ ARCHIVE FAILED — temp-state not cleaned" → STOP

---

MUST NOT modify or delete:
- `/obelisk/state/*`
- `/obelisk/guidelines/ai-engineering.md`
- Source code
- Git history

---

## Output

**If APPROVED:**
> "✅ TASK CLOSED — APPROVED
> Archived: `/obelisk/tasks/completed/[folder]/`"

**If CHANGES REQUIRED:**
> "⚠️ TASK CLOSED — CHANGES REQUIRED
> Archived: `/obelisk/tasks/rejected/[folder]/`"

STOP.