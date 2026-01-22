
---

**CURRENT STATE: TASK ARCHIVE & CLEANUP**

---

## Archive Steps

1. **Create directory:**  
   `/obelisk/tasks/completed/YYYYMMDD-short-task-name/`

2. **Copy to archive:**
   - `task.md`
   - `plan.md`
   - `implementation-notes.md` (if exists)
   - `review-notes.md` (if exists)

3. **Verify archive completeness**
   - All required files must exist
   - If incomplete → STOP  
     Output: `"CLOSE TASK BLOCKED — Incomplete archive"`

4. **Cleanup temporary state**
   - Delete ALL files from `/obelisk/temp-state/`
   - After cleanup, directory MUST be empty

---

## Protected State

You MUST NOT modify or delete:
- `/obelisk/state/*.domain.md`
- `/obelisk/state/tech-memory.md`
- `/obelisk/guidelines/ai-engineering.md`
- Source code
- Git history

---

## Final Output (MANDATORY)

Output EXACTLY one line:

**"TASK CLOSED — APPROVED. System ready for next task."**

STOP. End of workflow.
