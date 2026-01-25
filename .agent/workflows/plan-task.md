---
description: Create execution plan
---

**CURRENT STATE: TASK PLANNING**

Create a mechanical execution plan from the frozen task.

---

## Preflight

Read `/obelisk/temp-state/task.md`.

- **If missing:** → "❌ PLANNING BLOCKED — No task.md found" → STOP
- **If contains Open Questions:** → "❌ PLANNING BLOCKED — Unresolved open questions in task.md" → STOP

Read all `/obelisk/state/*.domain.md` contracts.

---

## Planning Rules

**MUST:**
- Follow the frozen task exactly
- Preserve all contracts
- Make the plan executable without interpretation

**MUST NOT:**
- Change, reinterpret, or extend the task
- Invent requirements or features
- Make unstated assumptions
- Write code or ask questions

### Testing

- If Testing Intent is specified in `task.md` → include only tests explicitly required
- If Testing Intent is omitted → follow defaults in `ai-engineering.md`
- Do NOT introduce additional tests or expand testing scope


---

## Blocking Conditions

STOP and load `/.agent/workflows/abort-task.md` if:
- Task is contradictory or impossible
- Task requires violating a contract
- Cannot respect all task constraints
- Technical infeasibility given current codebase

---

## Plan Output

Write to `/obelisk/temp-state/plan.md`:

```markdown
# Plan: [Task name]

## Goal
[Copied from task.md]

## Requirements Coverage
- [Success criterion 1] → Step [X]
- [Success criterion 2] → Steps [Y, Z]
- ...

## Scope

### Files to Modify
- `/path/file.ext` — [what changes]

### Files to Create
- `/path/new-file.ext` — [purpose]

## Execution Steps

1. [Step description]
   - Action: [exact change]
   - Output: [expected result]

2. ...

## Acceptance Criteria
[Copied from task.md]

## Must NOT Change
- [Contracts and protected behavior]
```

**All sections required.** Use "None" if a section has no items.

---

## Verification

Confirm `/obelisk/temp-state/plan.md` exists.

- **If missing:** → "❌ PLANNING FAILED — plan.md not created" → STOP

**Success:**
> "✓ PLANNING COMPLETE — `plan.md` created"
>
> `/implement-task` — run implementation
> `/abort-task` — Cancel and archive progress