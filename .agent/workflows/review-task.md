---
description: Validate implementation
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

**Read for verification:**
- All source files listed in `plan.md` under "Files to Modify" and "Files to Create"

---

## Review Rules

**MUST:**
- Review ONLY changes for this task
- Verify actual code matches plan (not just notes)
- Use frozen task as intent — do NOT reinterpret
- Treat contracts as immutable truth

**MUST NOT:**
- Propose fixes or alternatives
- Modify any files
- Re-run planning or implementation
- Approve based on notes alone — verify code

---

## Review Checklist

Any failure → **CHANGES REQUIRED**

1. **Task → Plan:** All success criteria mapped to steps?
2. **Plan → Code:** All steps actually implemented in source files?
3. **Contracts:** All preserved in actual code?
4. **Scope:** Only files listed in plan were changed?
5. **Divergences:** Any noted in implementation-notes.md justified?
6. Testing (if in scope)
   - [ ] Required tests exist
   - [ ] Tests protect stated intent (not implementation)

### Review Exclusions

Do NOT evaluate:
- Test quality or style
- Coverage percentages
- Tests outside task scope

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

## Files Verified
- [list of source files actually reviewed]

## Deferred Items (if any)
- [Item → requires new task]
```

---

## Verification

Confirm `/obelisk/temp-state/review-notes.md` exists.

- **If missing:** → "❌ REVIEW FAILED — review-notes.md not created" → STOP

**Success:**
> "✓ REVIEW COMPLETE — Status: [APPROVED|CHANGES REQUIRED]"

*Review always proceeds to archive regardless of status.*