---
description: implement obelisk task 
---


---

**CURRENT STATE: TASK IMPLEMENTATION**

Execute the approved plan **sequentially and deterministically**, with **mechanical discretion only**.

---

## Preflight

Read in order:
1. `/obelisk/state/*.domain.md`
2. `/obelisk/temp-state/plan.md`
3. `/obelisk/temp-state/task.md`
4. `/obelisk/state/tech-memory.md`
5. `/obelisk/guidelines/ai-engineering.md`

If any missing → STOP → Output: `"IMPLEMENTATION BLOCKED — Missing file: [path]"`

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
- Modify contracts, tech memory, or context files
- Ask questions
- Continue after a STOP condition

**STOP conditions apply only to semantic, scope, contract, or authority violations.**

---

## When to STOP

Stop immediately if:
- Ambiguity about **what** to build (not just how)
- Any impact on **correctness**, **scope**, or **observable behavior**
- Any conflict with **contracts** or frozen intent

and load `/obelisk/prompts/09-abort-task.prompt.md` 
with: 
- Aborted at: Implementation
- Reason: IMPLEMENTATION BLOCKED — [specific reason]

---

## Allowed Without Stopping

Proceed (and log in `implementation-notes.md`) for:
- Formatting / whitespace
- Variable renames (same meaning)
- Import reordering
- Syntax/API adjustments required by actual code state
- Defensive null checks matching existing patterns
- Mechanical micro-details fully determined by the plan

**Condition:** Observable behavior unchanged.  
**If uncertain → STOP.**
and load `/obelisk/prompts/09-abort-task.prompt.md` 
with: 
- Aborted at: Implementation
- Reason: IMPLEMENTATION BLOCKED — [specific reason]

---

## Implementation Notes (MANDATORY)

Create `/obelisk/temp-state/implementation-notes.md` after implementation.

**If divergences occurred:**
- What the plan specified
- What was done instead
- Why (mechanically necessary)

**If no divergences:**
Write: `"Plan implemented as specified. No divergences."`

Notes are factual only and have **no authority**.

**MANDATORY: Create this file after completing implementation, before reporting completion.**

---

## Execution Output

- Apply code changes to working branch
- Build/compile only if plan requires
- Do NOT run tests unless plan requires

---

## Implementation Exit

**VERIFICATION (MANDATORY):**
Confirm `/obelisk/temp-state/implementation-notes.md` exists.
If NOT → STOP → Output: `"IMPLEMENTATION FAILED — implementation-notes.md not created"`

> "IMPLEMENTATION COMPLETE
>
> Reply **'review'** to validate and archive."
> Reply **'abort'** to exit and archive progress."

**On "review":** Load `/obelisk/prompts/07-task-review-prompt.md`
**On "abort":** Load `/obelisk/prompts/abort-task.prompt.md` 
with: 
- Aborted at: Planning 
- Reason: User requested