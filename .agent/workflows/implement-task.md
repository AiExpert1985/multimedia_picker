---
description: Execute the planned task
---

**CURRENT STATE: TASK IMPLEMENTATION**

Execute the approved plan sequentially and deterministically.

---

## Preflight

**Required — STOP if missing:**
- `/obelisk/temp-state/task.md`
- `/obelisk/temp-state/plan.md`

**Read if present:**
- `/obelisk/state/*.domain.md` (contracts)
- `/obelisk/state/tech-memory.md`

---

## Execution Rules

**MUST:**
- Execute steps in exact order defined in plan
- Modify ONLY files listed in plan
- Preserve all contracts and protected behavior
- Stop immediately on any STOP condition

**MUST NOT:**
- Reinterpret, reorder, skip, or merge steps
- Fix plan errors silently
- Redesign or refactor beyond plan
- Modify contracts or tech-memory files
- Ask questions
- Continue after a STOP condition

---

## When to STOP

STOP and load `/.agent/workflows/abort-task.md` if:
- Ambiguity about **what** to build
- Impact on **correctness**, **scope**, or **observable behavior**
- Conflict with **contracts** or frozen intent
- **Uncertain** whether a change is safe

---

## Allowed Without Stopping

Proceed (and log in implementation-notes.md) for:
- Formatting / whitespace changes
- Variable renames (same meaning)
- Import reordering
- Syntax/API adjustments required by actual code state
- Defensive null checks matching existing patterns
- Mechanical micro-details fully determined by the plan

**Condition:** Observable behavior unchanged.

---

## Implementation Notes

Create `/obelisk/temp-state/implementation-notes.md` after implementation.

**If divergences:**
```markdown
## Divergences
- Plan specified: [X]
- Actual: [Y]
- Reason: [mechanically necessary because...]
```

**If no divergences:**
```markdown
Plan implemented as specified. No divergences.
```

---

## Execution Output

- Apply code changes to working branch
- Build/compile only if plan requires
- Do NOT run tests unless plan requires

---

## Verification

Confirm `/obelisk/temp-state/implementation-notes.md` exists.

- **If missing:** → "❌ IMPLEMENTATION FAILED — implementation-notes.md not created" → STOP

**Success:**
> "✓ IMPLEMENTATION COMPLETE — `implementation-notes.md` created"
>
> `/review-task` — run review
> `/abort-task` — Cancel and archive progress