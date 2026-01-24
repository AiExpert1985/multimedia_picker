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

Run each phase in order. After each, verify its output file exists before proceeding.

| Phase | Prompt | Output File |
|-------|--------|-------------|
| 1. Plan | `/obelisk/prompts/plan.md` | `plan.md` |
| 2. Implement | `/obelisk/prompts/implement.md` | `implementation-notes.md` |
| 3. Review | `/obelisk/prompts/review.md` | `review-notes.md` |
| 4. Archive | `/obelisk/prompts/archive.md` | *(clears temp-state)* |

**After each phase:**
- Verify output file exists in `/obelisk/temp-state/`
- If missing → STOP
- If phase issued STOP → STOP
- Otherwise → proceed to next phase

---

## Output

On completion:
> "✅ TASK COMPLETE — Archived to `/obelisk/tasks/completed/[folder]/`"

On failure:
> "❌ EXECUTION HALTED at [phase] — [reason]"