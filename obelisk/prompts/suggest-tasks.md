---
description: Suggest next tasks based on project state
---

**CURRENT STATE: TASK SUGGESTION**

Help user choose the next task to work on.

> **Scope:**
> This prompt is advisory only.
> It does NOT create tasks, modify files, or start discovery.

---

## 1. Input

`/suggest-tasks` or `/suggest-tasks [focus area]`

---

## 2. Gather Context

**Read in order (if present):**

1. `/obelisk/tasks/project-backlog.md` — explicit user intent
2. `/obelisk/tasks/completed/` — scan recent task.md files (last 10-15) for:
   - Completed work (exclude from suggestions)
   - Deferred items from review-notes.md (prioritize these)
3. `/obelisk/state/*.domain.md` — contracts
4. `/obelisk/state/tech-memory.md` — technical constraints
5. Source code `TODO` / `FIXME` markers — implicit intent

**Mode Selection:**

- **Backlog Mode:** If `project-backlog.md` has items → prioritize from backlog
- **Gap Analysis Mode:** If backlog empty/missing → infer tasks from:
  - Code TODOs/FIXMEs
  - Logical gaps (e.g., "schema exists, no migration")
  - Unimplemented contract requirements

---

## 3. Selection Criteria

**Suggest up to 3 tasks. Prioritize by:**

1. **Deferred items** — From recent completed task reviews
2. **Dependency unblock** — Tasks that enable other work
3. **Risk reduction** — Tasks touching critical/fragile areas (flag these)
4. **Code health** — Critical FIXMEs, high-debt TODOs
5. **Logical gaps** — Missing pieces implied by existing code
6. **Complexity isolation** — Simpler tasks when priority is equal

**Exclude:**
- Tasks matching completed task.md goals
- Work outside current focus area (if provided)

**Flag:** Tasks likely requiring contract changes

---

## 4. Output

```
**Suggested Next Tasks:**

1. [Task Name]
   Why: [One sentence - dependency/risk/gap]
   → `/new-task [Task Name]`

2. [Task Name]
   Why: [One sentence]
   → `/new-task [Task Name]`

3. [Task Name]
   Why: [One sentence]
   → `/new-task [Task Name]`

**Blockers:** [if any, else "None"]
**Contract Changes Likely:** [task numbers, or "None"]
```

---

## 5. Edge Cases

**No tasks found:**
> "No pending items in backlog or code TODOs.
> Describe what you want to build: `/new-task [description]`"

**Focus area has no matches:**
> "No tasks matching '[focus]'. Showing general suggestions instead:"
> [Continue with normal output]

---

## 6. Exit

> "Copy a command above to start, or `/suggest [different focus]` for other options."

**Do NOT create files or begin discovery.**