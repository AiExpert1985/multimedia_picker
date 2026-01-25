---
description: Auto-execute task until the end
---

**CURRENT STATE: EXECUTE**

Run planning → implementation → review → archive sequentially.

---

## Preflight

Check `/obelisk/temp-state/task.md` exists.
- **If missing:** → "❌ No task defined. Use `/new-task` first." → STOP

---

## Execution Sequence

For each phase: **Read the prompt file, treat content as instructions, execute.**

| Phase | Prompt | Output Verification |
|-------|--------|---------------------|
| 1. Plan | `/.agent/workflows/plan-task.md` | `plan.md` exists |
| 2. Implement | `/.agent/workflows/implement-task.md` | `implementation-notes.md` exists |
| 3. Review | `/.agent/workflows/review-task.md` | `review-notes.md` exists |
| 4. Archive | `/.agent/workflows/archive-task.md` | `/obelisk/temp-state/` is empty |

**Logic Rules:**
1.  **Stop on Failure:** If Verification fails (or Review ≠ APPROVED), **STOP** immediately.
2.  **Stop on Success:** Once Phase 4 (Archive) completes, the workflow ends.
    * *Do not output a separate completion message.*

---

## Output (Errors Only)

**If sequence stops early:**
> "❌ **EXECUTION HALTED at [Phase]**
> **Reason:** [Missing File / Review Rejected]