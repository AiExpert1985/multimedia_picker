---
description: finalize obelisk task, and make it ready for planning
---

**CURRENT STATE: TASK FREEZE**

Extract and stabilize intent from completed discovery discussion.

Produces: `/obelisk/temp-state/task.md`

---

## Preflight

Read in order:

1. `/obelisk/state/*.domain.md`
2. `/obelisk/state/tech-memory.md`
3. `/obelisk/guidelines/ai-engineering.md`

If any missing → STOP → Output: `"TASK FREEZE BLOCKED — Missing file: [path]"`

---

## Contract Update (If Needed)

If discovery revealed a new or incorrect invariant:
- Update ONLY if explicitly approved by the human
- Capture exactly as discussed
- If uncertain → record in Open Questions

---

## Extraction Rules

**MUST:**
- Use ONLY content from current discussion
- Produce exactly ONE task
- Record unresolved items in Open Questions

**MUST NOT:**
- Invent, refine, or reinterpret intent
- Add design or implementation details
- Ask questions

---

## Task Output

Write to: `/obelisk/temp-state/task.md`

```markdown
# Task: [One-line name]

## Goal
[What must be achieved and why]

## Scope
✓ Included: [in scope]
✗ Excluded: [out of scope]

## Constraints
- [Contracts to preserve]
- [Technical / business limits]
- [Areas that must NOT change]

## Implementation Preferences (if any)
- [Preferred approaches — guide planning, not requirements]

## Success Criteria
- [Observable completion signals]

## Open Questions (if any)
- [Unresolved ambiguities]
```

**MANDATORY: Create this file immediately after extraction.**

---

## Freeze Exit

After creating `task.md`:

**VERIFICATION (MANDATORY):**
Confirm `/obelisk/temp-state/task.md` exists.
If NOT → STOP → Output: `"TASK FREEZE FAILED — task.md not created"`

Otherwise, load and execute: `/obelisk/prompts/05-task-planning-prompt.md`