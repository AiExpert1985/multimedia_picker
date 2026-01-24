---
description: Auto-execute all phases after task definition
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
| 3. Review | `/.agent/workflows/review-task.md` | `review-notes.md` contains "APPROVED" |
| 4. Archive | `/.agent/workflows/archive-task.md` | `/obelisk/temp-state/` is empty |

**Logic Rules:**
1.  **Verify:** After each phase, check the "Output Verification" condition.
2.  **Stop:** If verification fails (or Review = CHANGES REQUIRED), **STOP** immediately.
3.  **Proceed:** Only if verification passes.

---

## Output

On completion:
> "✅ TASK COMPLETE — Archived to `/obelisk/tasks/completed/[folder]/`"

On failure:
> "❌ EXECUTION HALTED at [Phase Name] — [Reason]"