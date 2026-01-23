---
description: Start new obelisk task
---


**CURRENT STATE: TASK DISCOVERY**

You are starting a **NEW TASK** in Obelisk.

Task Discovery is a **discussion-only** phase whose goal is to freeze **intent**, not design solutions.

---

## EXECUTION GUARD (CRITICAL)

Task Discovery is discussion-only. You MUST NOT:
- Modify files, create plans, or execute code
- Proceed to freeze, planning, or implementation

Execution before explicit user command ("plan", "fast path", "abort") is a protocol violation.

If execution is triggered implicitly by the agent → STOP immediately.

---

## Initial Prompt

Output ONLY:
> "Please describe the task you'd like to work on."

Then wait for user input.

---

## Preflight (Execute AFTER user describes task)

### 1. Verify Clean Workspace
Check `/obelisk/temp-state/` for:
- `task.md`
- `plan.md`
- `implementation-notes.md`
- `review-notes.md`

If ANY exist → STOP → Output: `"INCOMPLETE TASK CYCLE DETECTED — Resolve before starting new task"`

### 2. Read Authoritative Files
- `/obelisk/state/*.domain.md`
- `/obelisk/state/tech-memory.md`
- `/obelisk/guidelines/ai-engineering.md`

If any missing → STOP → Output: `"START TASK BLOCKED — Missing file: [path]"`

Then proceed to Code Reconnaissance.

---

## Authority Hierarchy

Highest → lowest:
1. Contracts (`*.domain.md`)
2. Frozen Task (`task.md`)
3. Plan (`plan.md`)
4. Tech Memory
5. AI Engineering Rules

Chat history is non-authoritative.

---

## Code Reconnaissance (MANDATORY — Before Questions)

After the user describes the task, and before asking questions:

- Identify relevant files/components (state explicitly if none exist)
- Observe current behavior, gaps, and patterns
- Use reconnaissance internally to inform questions and risk detection

**Rules:**
- Treat code as descriptive evidence only
- Do NOT infer intent, decide approach, narrow solutions, or propose directions
- Do NOT present observations to the user

**Output:** After completing reconnaissance, output only:
> "Related code reviewed."

---

## Discovery Flow

### Immediate Convergence (Optional)
Skip questioning if ALL are true:
- Task fits Minimal Task Spec
- Intent, scope, success criteria explicit
- No contract conflicts suspected
- No architectural impact

Otherwise → **Initial Understanding**
- What, why, for whom
- Success criteria
- Scope boundaries (in/out)
- Key constraints

→ **Refinement** (only if needed)
- Resolve ambiguities
- Surface risks or contract conflicts
- Flag task split if required

Max two rounds, then converge.

---

## Question Rules

Ask ONLY questions affecting:
- Task definition
- Scope or boundaries
- Feasibility
- Required constraints

- Recommendations are allowed ONLY when grounded in existing code patterns or explicit preferences
- NEVER recommend refactors or architecture changes unless requested
- Do NOT design solutions or commit to implementation details

---

## Contract Awareness

If a new invariant is needed or existing one is wrong:

1. Propose specific change (current → proposed, why)
2. Ask: "Should I update the contract now?"
3. Wait for explicit yes/no
4. If approved → update file immediately
5. If rejected → record as task constraint

Updates occur **only** at explicit approval points.

---

## Discovery Phase Rules

You MUST NOT:
- Create or freeze tasks
- Create plans
- Write or modify files (except approved contract/tech-memory updates)
- Propose code or make decisions for the user

You MAY:
- Restate intent
- Highlight risks or contract conflicts
- Suggest splitting work
- Reference contracts or tech-memory

---

## Convergence

When ready:
1. Stop questioning
2. Present task summary
3. Ask for confirmation or correction

**Summary must be:**
- Scannable in ~30 seconds
- ✓/✗ for scope
- One sentence per item
- Risks flagged concisely

**On corrections:**
- Output only: "Updated: [changed items]" or "Added: [new items]"
- Regenerate full summary only if changes are substantial or user requests it

**CRITICAL:** You MUST wait for user response after presenting summary.
Do NOT proceed to freeze, planning, or implementation automatically.


---

## Task Summary Format

```markdown
**Task Intent:**  
[One sentence: what must be done and why]

**Scope:**  
✓ Included: [concise bullets, one line each]  
✗ Excluded: [concise bullets, one line each]

**Success Criteria:**  
- [Observable signals - one per line, no sub-bullets]

**Constraints:**  
- [Contracts that must be preserved]
- [Critical technical/business limits]

**Approach:** [If decided during discovery]  
[One sentence describing chosen direction and why]

**Risks:**  
- [Unresolved items - brief, one line each]

**Assessment:**  
Single task | Split into N tasks | Contract update required
```

---

## Discovery Exit

> "Reply **'plan'** to freeze task and generate plan.
> Reply **'abort'** to exit and archive progress.
> Reply **'fast path'** to freeze, plan, implement, review, and archive automatically.
> Or describe corrections."

**You MUST wait for one of these responses before proceeding.**

**On "plan":** Load `/obelisk/prompts/04-task-freeze-prompt.md`
**On "fast path":** Load `/obelisk/prompts/fast-path-prompt.md`
**On "abort":** Load `/obelisk/prompts/abort-task.prompt.md` with:
  - Aborted at: Discovery
  - Reason: User requested
**On corrections:** Update summary, ask again.