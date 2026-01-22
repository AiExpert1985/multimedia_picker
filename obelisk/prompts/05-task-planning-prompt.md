
---

**CURRENT STATE: TASK PLANNING**

Create a mechanical execution plan from the frozen task.

Produces: `/obelisk/temp-state/plan.md`

---

## Planning Rules

**MUST:**
- Follow the frozen task exactly
- Preserve all contracts
- Respect all task constraints
- Make the plan executable without interpretation

**MUST NOT:**
- Change, reinterpret, or extend the task
- Invent requirements or features
- Redesign architecture
- Make unstated assumptions
- Write code
- Ask questions

---

## Blocking Conditions

STOP immediately if:
- `/obelisk/temp-state/task.md` is missing
- Task is contradictory or impossible
- Task requires violating a contract
- Cannot respect all constraints

**If blocked:**  
Load `/obelisk/prompts/09-abort-task.prompt.md` 
with: 
- Aborted at: Planning
- Reason: PLANNING BLOCKED — [specific reason]

---

## Open Questions Handling

If `task.md` contains Open Questions:
- Treat as archival context only
- Do NOT ask for clarification
- Do NOT let it block planning
- Proceed only if task is otherwise complete and consistent

---

## Plan Output

Write **exactly ONE** plan to: `/obelisk/temp-state/plan.md`

**Format:**

```markdown
# Plan: [Task name from task.md]

## Goal
[Copied verbatim from task.md]

## Requirements Coverage
- [Success criterion 1] → Step [X]
- [Success criterion 2] → Steps [Y, Z]

## Scope

### Files to Modify
- `/path/file.ext` — [what changes]

### Files to Create
- `/path/new-file.ext` — [purpose]

### Files Explicitly Excluded
- `/path/protected.ext` — [why excluded]

## Execution Steps

1. [Concrete step]
   - Input: [before state]
   - Action: [exact change]
   - Output: [after state]

2. ...

## Acceptance Criteria
[Copied from task.md]

## Must NOT Change
- [Contracts]
- [Protected files / behavior]

## Assumptions (Explicitly Accepted in Task)
[List only assumptions explicitly stated or implied in `task.md`.
Do NOT introduce new assumptions.]

## Implementation Preferences (Optional, Non-Binding)

- Preferences or options explicitly discussed during Task Discovery
- These guide planning when multiple valid approaches exist
- These are NOT requirements and must not override contracts, task scope, or constraints
```

**MANDATORY: Create this file before reporting completion.**

---

## Planning Exit

**VERIFICATION (MANDATORY):**
Confirm both files exist:
- `/obelisk/temp-state/task.md`
- `/obelisk/temp-state/plan.md`

If either missing → STOP → Output: `"PLANNING FAILED — Required file(s) not created"`

**Success:**
> "TASK DEFINED — Files: `task.md`, `plan.md`
>
> Reply **'implement'** to execute the plan.
> Reply **'review'** to validate implementation."
> Reply **'abort'** to exit and archive progress."

**On "implement":** Load `/obelisk/prompts/06-task-implementation-prompt.md`
**On "review":** Load `/obelisk/prompts/07-task-review-prompt.md`
**On "abort":** Load `/obelisk/prompts/abort-task.prompt.md` 
with: 
- Aborted at: Planning 
- Reason: User requested