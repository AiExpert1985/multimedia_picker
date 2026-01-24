---
description: Validate implementation matches frozen intent
---

**CURRENT STATE: TASK REVIEW**

Role: **Reviewer** — Validate execution matches frozen intent.

---

## Preflight

**Required — STOP if missing:**
- `/obelisk/temp-state/task.md`
- `/obelisk/temp-state/plan.md`
- `/obelisk/temp-state/implementation-notes.md`

→ "❌ REVIEW BLOCKED — Missing file: [path]"

**Read if present:**
- `/obelisk/state/*.domain.md` (contracts)

---

## Review Rules

**MUST:**
- Review ONLY changes for this task
- Base evaluation on written files only
- Use frozen task as intent — do NOT reinterpret
- Treat contracts as immutable truth

**MUST NOT:**
- Propose fixes or alternatives
- Modify any files
- Re-run planning or implementation
- Approve undocumented behavior

---

## Review Checklist

Any failure → **CHANGES REQUIRED**

1. **Task → Plan:** All success criteria mapped to steps?
2. **Plan → Code:** All steps executed as specified?
3. **Contracts:** All preserved?
4. **Scope:** Only files listed in plan were changed?
5. **Divergences:** Any noted in implementation-notes.md justified?

---

## Review Output

Write to `/obelisk/temp-state/review-notes.md`:

```markdown
# Review Outcome

**Status:** APPROVED | CHANGES REQUIRED

## Summary
[2-3 sentence factual summary]

## Checklist Results
1. Task → Plan: ✓ | ✗ [detail if failed]
2. Plan → Code: ✓ | ✗
3. Contracts: ✓ | ✗
4. Scope: ✓ | ✗
5. Divergences: ✓ | ✗

## Deferred Items (if any)
- [Item → requires new task]
```


---

## Verification

Confirm `/obelisk/temp-state/review-notes.md` exists.

- **If missing:** → "❌ REVIEW FAILED — review-notes.md not created" → STOP

**Success (either status):**
> "✓ REVIEW COMPLETE — Status: [APPROVED|CHANGES REQUIRED]"


*Review always proceeds to archive regardless of status.*

Load `/.agent/workflows/archive-task.md`