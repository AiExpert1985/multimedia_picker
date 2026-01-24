---
description: Update existing task based on user feedback
---

**CURRENT STATE: TASK UPDATE**

Refine an existing frozen task and pass it to `/new-task`.

> **Scope:**
> `/update-task` reformulates task intent only.
> Validation, questioning, contracts, and freezing are handled by `/new-task`.

---

## 1. Input

- `/update-task [description]` → `update_req`
- `/update-task` → Ask: “What changes are required (scope, constraints, or success criteria)?” → Wait

**Guard:**
If `update_req` is vague (e.g., "improve it"):
> “Please specify concrete changes (scope, constraints, or success criteria).”
→ Wait

---

## 2. Load Task

Read `/obelisk/temp-state/task.md`.

- **If missing:**
  > “❌ No task to update. Use `/new-task`.” → STOP
- **If exists:**
  Rename to `/obelisk/temp-state/task.md.backup`

---

## 3. Build Refinement Context (Internal)

Construct internally (do not output):

> **CONTEXT: TASK REFINEMENT**
>
> **BASE STATE (Current Task):**
> [Content of task.md.backup]
>
> **MODIFICATION REQUEST:**
> “[update_req]”
>
> **MERGE RULES:**
> 1. Modification Request overrides Base State on conflict.
> 2. If scope is removed, remove related constraints/criteria.
> 3. If scope is added, infer necessary constraints.
> 4. Result must be a complete, self-contained task definition.

---

## 4. Delegate

Output once:
> “Updating task: [one-line summary of change]. Handing off to Discovery...”

**Action:**
1. **LOAD** `/obelisk/prompts/new-task.md`
2. **INJECT** the **Refinement Context** (from Step 3) as the *initial user input*.
3. **EXECUTE** the `new-task` prompt immediately.

---

## 5. Cleanup

- **On Success (Task Freeze Complete):**
  - Delete `/obelisk/temp-state/task.md.backup`

- **On Abort/Failure:**
  - Restore `/obelisk/temp-state/task.md.backup` → `/obelisk/temp-state/task.md`
  - Output: "Update aborted. Original task restored."