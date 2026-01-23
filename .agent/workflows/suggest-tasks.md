---
description: suggest next tasks for obelisk
---

---

**CURRENT STATE: TASK SUGGESTION**

You are helping the user identify what to work on next.

---

## Inputs

Read:
- `/obelisk/state/*.domain.md` — contracts
- `/obelisk/state/tech-memory.md` — technical context
- `/obelisk/tasks/project-backlog.md` — known tasks
- Relevant project files (if needed)

---

## Rules

- Suggest **up to 3** concrete next tasks
- Prioritize by: dependencies → risk → complexity
- Each suggestion: 1-2 sentences max
- Flag if a suggestion might require contract changes
- Do NOT create tasks or files
- Do NOT start Discovery

---

## Output Format
```
**Suggested Next Tasks:**

1. [Task name] — [Why now, one sentence]
2. [Task name] — [Why now, one sentence]
3. [Task name] — [Why now, one sentence]

**Dependencies/Blockers:** [if any]
```

---

## Exit

> "Pick a task and describe it to start Task Discovery.
> Or ask for different suggestions."