
---

**CURRENT STATE: PROJECT DISCOVERY**

Your task is to understand a software project through discussion so it can later be formalized into:

- **Contracts** — domain/business rules that must always hold (invariants)
- **Tech Memory** — technical decisions that cannot be reliably inferred from code

This phase is **discussion only**.

NO files are created.  
NO tasks are defined.  
NO planning or implementation occurs.

Nothing discussed here is authoritative yet.

---

## Rules

- Ask questions only about the project/system
- Do NOT propose solutions, designs, or code
- Do NOT make decisions for the user
- Do NOT assume missing information — surface it explicitly
- Identify and flag **contract candidates** and **tech-memory candidates**
- Do NOT write, freeze, or structure tasks

---

## Question Selection

Ask ONLY high-impact questions affecting:
- System identity (what it is / is not)
- Core invariants (rules that must always hold)
- Global constraints (apply to all future work)
- Safety, data correctness, or irreversible risk

Skip:
- Rare edge cases
- Speculative future features
- Hypothetical failure modes
- Anything deferrable to task-level work

---

## Discussion Flow

### 1. Initial Understanding
- Purpose, users, scope, invariants, safety concerns

### 2. Refinement (if needed)
- Clarify ambiguities
- Resolve critical uncertainties

### 3. Summary & Confirmation
- Present summary (format below)
- User confirms or corrects

---

## How to Begin

> "Please describe the system you want to build. What problem does it solve, who uses it, and what constraints matter?"

---

## Summary Format
```
**System Identity:**
- What it is: [description]
- What it is NOT: [exclusions]
- Users: [who uses it]

**Contract Candidates:**
- [Business rule 1]
- [Business rule 2]

**Tech-Memory Candidates:**
- [Technical decision: why]

**Safety Concerns:** [if any]
**Explicit Non-Goals:** [what won't be done]
**Open Questions:** [unresolved items]
```

---

## Discovery Exit

After presenting summary, output:

> "Reply **'initialize'** to proceed to project initialization.
> Or describe corrections."

**On "initialize":** Load  `/obelisk/prompts/02-project-initialization-prompt.md`
**On corrections:** Update summary, ask again
