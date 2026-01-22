
---

# Obelisk Framework

## Overview

Obelisk is a framework for **human–AI collaboration** designed to make AI-assisted development **safe, repeatable, and recoverable** over long-running projects.

> **AI does not fail because it is weak — it fails because long-term use is unmanaged.**

Obelisk prevents silent damage by separating **truth**, **intent**, and **execution** into explicit, file-based authority layers:

1. **Contracts** — versioned business invariants (authoritative)
2. **Task** — frozen, human-approved intent (temporary)
3. **Plan** — mechanical execution steps (temporary)
4. **Execution** — code and tests (disposable)

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

## Task Lifecycle

Each task runs in an isolated cycle:

1. **Discovery** — Clarify intent, scope, constraints (no files created)
2. **Freeze** — Lock task as `task.md`
3. **Plan** — Generate mechanical execution steps as `plan.md`
4. **Implementation** — Execute plan literally, record deviations
5. **Review** — Validate execution against plan and contracts
6. **Archive & Cleanup** — Store task materials, clean workspace

Tasks and plans are disposable by design.

---

## Contract Evolution

Contracts evolve only at explicit approval points during Discovery.
During Execution, contracts are frozen.
All changes tracked via Git.

Tech-memory follows the same approval flow.

---

## Scope of This File

This README provides **orientation only**.

It does **not**:
- Define project-specific rules
- Override contracts, tasks, or plans
- Participate in authority resolution

Correctness is enforced by contracts, frozen tasks, and execution rules — not this document.