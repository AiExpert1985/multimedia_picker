---
description: Suggest next tasks based on project state
---

**CURRENT STATE: TASK SUGGESTION**

Help the user choose the next task to work on.

> **Scope:** Advisory only. Does NOT create tasks or modify code.

---

## 1. Input

- `/suggest-task`
- `/suggest-task [focus area]` (e.g., "auth", "ui", "refactor")

---

## 2. Gather Context

**Read in order (if present):**

1.  **Explicit Intent:**
    - `/obelisk/tasks/project-backlog.md`

2.  **Project History (Context Window Optimized):**
    - Scan `/obelisk/tasks/completed/` (last 5-10 entries).
    - **Read ONLY:**
      - `task.md` (Header/Goal only) → *To exclude completed work.*
      - `review-notes.md` ("Deferred Items" section only) → *To find prioritized carry-over work.*

3.  **Constraints:**
    - `/obelisk/state/*.domain.md`
    - `/obelisk/state/tech-memory.md`

4.  **Implicit Intent (Gap Analysis):**
    - Source code scanning for `TODO`, `FIXME`, `HACK`.

---

## 3. Mode Selection & Filtering

**Mode:**
- **Backlog Mode:** If `project-backlog.md` has items → Prioritize these.
- **Gap Analysis Mode:** If backlog empty → Infer from TODOs, logical gaps, or deferred items.

**Selection Criteria (Top 3):**
1.  **Deferred Items:** (Highest Priority) Items explicitly flagged in previous `review-notes.md`.
2.  **Unblockers:** Tasks that resolve dependencies for other known goals.
3.  **Code Health:** Critical `FIXME` or high-debt `TODO` markers.
4.  **Logical Gaps:** (e.g., "Schema exists but no API endpoint").

**Exclusions:**
- Goals that strictly match recently completed `task.md` headers.
- Items unrelated to `[focus area]` (if user provided one).

---

## 4. Output

**Suggested Next Tasks:**

> **1. [Task Name]**
>    - **Why:** [Reason: e.g., "Deferred from Task #12", "Unblocks User Profile"]
>    - **Command:** `/new-task [Task Name]`
>
> **2. [Task Name]**
>    - **Why:** [Reason]
>    - **Command:** `/new-task [Task Name]`
>
> **3. [Task Name]**
>    - **Why:** [Reason]
>    - **Command:** `/new-task [Task Name]`

**Blockers:** [if any, else "None"]
**Contract Changes Likely:** [Task #s or "None"]

---

## 5. Edge Cases

- **No tasks found:**
  > "No pending items in backlog or code TODOs.
  > **Command:** `/new-task [describe feature]`"

- **Focus area mismatch:**
  > "No tasks matching '[focus]'. Showing general suggestions instead:"
  > [Continue with normal output]

---

## 6. Exit

> "Copy a command above to start."
> **STOP.**