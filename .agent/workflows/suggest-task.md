---
description: Suggest next tasks
---

**CURRENT STATE: TASK SUGGESTION**

Help the user choose the next task to work on.

> **Scope:** Advisory only. Does NOT create tasks or modify files.

---

## 1. Input

- `/suggest-task`
- `/suggest-task [focus area]` (e.g., "auth", "ui", "refactor")

---

## 2. Gather Context

**Read in order (if present):**

### A. Explicit Intent
- `/obelisk/tasks/project-backlog.md`

### B. Project History
- `/obelisk/tasks/project-history.md`

**Extract:**
1. Task sequence pattern (chronological order, types, scopes)
2. Deferred items (explicit carry-over work)
3. Completed work (to exclude from suggestions)
4. Aborted/rejected patterns (potential retry candidates)

**If file missing or empty:**
- Note: "No task history yet—suggestions based on backlog and code analysis."
- Skip sequence analysis

**Do NOT scan `/obelisk/tasks/completed/` directories.** History file is authoritative for suggestions.

### C. Constraints
- `/obelisk/state/*.domain.md`
- `/obelisk/state/tech-memory.md`

### D. Implicit Intent (Code Gaps)
- Source code `TODO`, `FIXME`, `HACK` markers
- Logical gaps (e.g., "schema exists, no API endpoint")

---

## 3. Generate Candidates (Internal)

**Generate 8-10 candidate tasks internally.** Do not output this list.

**Sources for candidates:**

| Source | Weight | Description |
|--------|--------|-------------|
| Deferred Items | Highest | Explicitly flagged in previous review-notes.md |
| Sequence Continuation | High | What logically follows the completed task pattern? |
| Backlog Items | Medium | Listed in project-backlog.md |
| Unblockers | Medium | Tasks that enable other known goals |
| Code Health | Low | Critical FIXME/TODO markers |
| Logical Gaps | Low | Missing pieces implied by existing code |

**Sequence Analysis:**

Examine the chronological order of recent completed tasks:
```
Task 1: Setup Database
Task 2: Create User Model  
Task 3: Add User Repository
Task 4: Create User API endpoints
→ Pattern: Building User feature bottom-up (data → API)
→ Likely next: User authentication, User validation, or User UI
```

Use this pattern to inform candidate generation.

---

## 4. Prioritize (Internal)

**From the 8-10 candidates, select top 3 based on:**

1. **Deferred Items** — Highest priority (explicit carry-over)
2. **Sequence Fit** — Continues natural progression from completed work
3. **Unblockers** — Enables other tasks
4. **Backlog Position** — Higher in backlog = higher priority
5. **Complexity** — Simpler tasks win ties

**Rule: Deferred items always outrank sequence fit when both apply.**

**Exclude:**
- Tasks matching completed task.md goals
- Tasks unrelated to `[focus area]` if user specified one

**Flag:** Tasks likely requiring contract changes

---

## 5. Output

```
**Suggested Next Tasks:**

1. [Task Name]
   Why: [Reason - e.g., "Continues auth feature sequence", "Deferred from Task #12"]
   → `/new-task [Task Name]`

2. [Task Name]
   Why: [Reason]
   → `/new-task [Task Name]`

3. [Task Name]
   Why: [Reason]
   → `/new-task [Task Name]`

**Primary influence:** [Signal used - e.g., "Sequence of 8 recent tasks + 2 deferred items"]
**Blockers:** [if any, else "None"]
**Contract Changes Likely:** [Task #s or "None"]
```

---

## 6. Edge Cases

**No completed tasks yet:**
- Skip sequence analysis
- Rely on backlog and code gaps only
- Note: "No task history yet—suggestions based on backlog and code analysis."

**No tasks found:**
> "No pending items in backlog, deferred work, or code TODOs.
> → `/new-task [describe what you want to build]`"

**Focus area has no matches:**
> "No tasks matching '[focus]'. Showing general suggestions instead:"
> [Continue with normal output]

**Sequence pattern unclear:**
- If completed tasks don't show clear pattern (random order, mixed features)
- Weight sequence analysis lower, rely more on backlog and deferred items

---

## 7. Exit

> "Copy a command above to start, or `/suggest-task [different focus]` for other options."

**STOP.**