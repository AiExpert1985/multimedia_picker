how do you evaluate updated final version ?

# Obelisk Framework

## Overview

Obelisk is a framework for **human–AI collaboration** designed to make AI-assisted development **safe, repeatable, and recoverable** over long-running projects.

> **AI does not fail because it is weak — it fails because long-term use is unmanaged.**

Obelisk prevents silent damage by separating **truth**, **intent**, and **execution** into explicit, file-based authority layers:

1. **Contracts** — versioned business invariants (authoritative)
2. **Task** — frozen, human-approved intent (temporary)
3. **Plan** — mechanical execution steps (temporary)
4. **Execution** — code changes (tests/builds only if required by plan)

Higher layers constrain lower ones. Lower layers must never redefine higher ones.

**Contracts define truth. Tasks freeze intent. Plans constrain execution. Everything else is disposable.**

---

## Core Properties

- Files are the source of truth — chat history is not
- Sessions are stateless — models are interchangeable
- Intent is frozen before execution
- History lives in Git, not prompts
- Recovery matters more than perfection

---

## Quick Start

**New project:**
```
/start-project
```

**Existing project (no setup needed):**
```
/new-task [description]
/execute
```

**Not sure what to work on:**
```
/suggest-task
```

---

## Commands

| Command | Purpose |
|---------|---------|
| `/start-project` | Initialize Obelisk for a new project (discovery → contracts) |
| `/suggest-task` | Get task recommendations based on backlog and code state |
| `/new-task [desc]` | Define a new task through discovery |
| `/update-task [changes]` | Modify task before execution |
| `/execute` | Run plan → implement → review → archive automatically |
| `/abort-task` | Cancel current task and archive progress |

Individual phases can be run manually:
`/plan-task`, `/implement-task`, `/review-task`, `/archive-task`

---

## Task Lifecycle

Each task runs in an isolated cycle:

```
/new-task → task.md
    ↓
/plan-task → plan.md
    ↓
/implement-task → implementation-notes.md + code changes
    ↓
/review-task → review-notes.md (APPROVED | CHANGES REQUIRED)
    ↓
/archive-task → /completed/ or /rejected/
```

`/execute` runs all phases after `/new-task` automatically.

---

## File Structure

```
/obelisk/
├── state/
│   ├── core.domain.md        # Project-wide contracts
│   ├── [feature].domain.md   # Feature-specific contracts
│   └── tech-memory.md        # Technical decisions
├── temp-state/
│   ├── task.md               # Current task (frozen intent)
│   ├── plan.md               # Execution plan
│   ├── implementation-notes.md
│   └── review-notes.md
├── tasks/
│   ├── project-backlog.md    # Human reference only
│   ├── completed/            # Approved tasks
│   ├── rejected/             # Tasks needing revision
│   └── aborted/              # Cancelled tasks
└── .agent/workflows/         # Prompt files
```

---

## Contract Evolution

Contracts evolve only at explicit approval points during Discovery.
During Execution, contracts are frozen.
Rejected tasks do not modify contracts or tech-memory.
All changes tracked via Git.

---

## Scope of This File

This README provides **orientation only**.

It does **not**:
- Define project-specific rules
- Override contracts, tasks, or plans
- Participate in authority resolution

Correctness is enforced by contracts, frozen tasks, and execution rules — not this document.