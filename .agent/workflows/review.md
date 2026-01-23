---
description: review obelisk task
---


---

**CURRENT STATE: TASK REVIEW**

Role: **Reviewer** — Validate execution matches frozen intent.

---

## Review Inputs

Read:
- `/obelisk/temp-state/task.md`
- `/obelisk/temp-state/plan.md`
- `/obelisk/temp-state/implementation-notes.md`
- `/obelisk/state/*.domain.md`

If any missing → STOP  
Output: `"REVIEW BLOCKED — Missing file: [path]"`

---

## Review Rules

**MUST:**
- Review ONLY changes for this task
- Base evaluation on written files only
- Use frozen task as intent — do NOT reinterpret
- Treat contracts as immutable truth

**MUST NOT:**
- Propose fixes or alternatives
- Modify files
- Re-run planning or implementation
- Approve undocumented behavior
- Evaluate style or performance

---

## Review Checklist

Any failure → **CHANGES REQUIRED**

1. **Task → Plan:** All requirements covered?
2. **Plan → Implementation:** Executed as specified?
3. **Contracts:** All preserved?
4. **Scope:** Only listed files changed?
5. **Implementation Notes:** Any blocking item present?

---

## Review Output

Write to: `/obelisk/temp-state/review-notes.md`
### Format


```markdown
# Review Outcome

**Status:** APPROVED | CHANGES REQUIRED

## Summary
[Factual summary of findings]

## Notes
- [Issue or confirmation with reference]

## Deferred Items (if any)
- [Item → requires new task]

```

**MANDATORY: Create this file before proceeding to archive.**

---

## Review Exit

**VERIFICATION (MANDATORY):**
Confirm `/obelisk/temp-state/review-notes.md` exists.
If NOT → STOP → Output: `"REVIEW FAILED — review-notes.md not created"`

After successfully creating `review-notes.md`:
Load `/obelisk/prompts/08-archive-and-cleanup-prompt.md`