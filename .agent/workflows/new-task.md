---
description: Creates a new Obelisk task
---

**CURRENT STATE: TASK DISCOVERY**

Define a new task through discussion.

---

## EXECUTION GUARD (CRITICAL)

Task Discovery defines intent. You MUST NOT proceed to planning or implementation automatically.

Allowed: Update contracts, tech-memory, create task.md  
Forbidden: Create plans, modify code, execute plans

If execution is triggered implicitly by the agent → STOP immediately.

---

## Entry Point Detection

**Check if task description was provided:**

**IF user provided description:**
```
/new-task Add image picker to main screen
```
- Extract task_description = "Add image picker to main screen"
- Proceed to Preflight

**IF no description:**
```
/new-task
```
- Output: "Please describe the task you'd like to work on."
- Wait for response
- Set task_description = [response]
- Proceed to Preflight

---

## Preflight

### 1. Clean Workspace

Delete all files in `/obelisk/temp-state/` (if any exist).

### 2. Load Authoritative Files

Load all existing files:
- `/obelisk/state/*.domain.md` (all domain contracts)
- `/obelisk/state/tech-memory.md`
- `/obelisk/guidelines/ai-engineering.md`

Missing files are OK. Continue with what exists.

---

## Authority Hierarchy

Highest → lowest:
1. Contracts (`*.domain.md`)
2. Frozen Task (`task.md` - created at end)
3. Tech Memory (`tech-memory.md`)
4. AI Engineering Rules (`ai-engineering.md`)

Chat history is non-authoritative.

---

## Code Reconnaissance (MANDATORY)

After loading contracts, before validation:

- Identify relevant files/components
- Observe current behavior, gaps, and patterns
- Use reconnaissance internally to inform questions and risk detection

**Rules:**
- Treat code as descriptive evidence only
- Do NOT infer intent or propose directions
- Do NOT present observations to the user

**Output:** After completing reconnaissance, output only:
> "Related code reviewed."

---

## Discovery Questions

**After Code Reconnaissance:**

---

### Set 1: Understanding (MANDATORY)

**Purpose:** Clarify the task. Contracts and testing noted internally, not asked yet.

**Always ask at least one question**, even if task seems clear.

**📌 Questions:**
- What, why, for whom
- Success criteria (observable completion signals)
- Scope boundaries (what's in/out)
- Key constraints or dependencies

**Internal (silent):**
- Note potential contract conflicts for Set 2
- Note testing implications for Set 2

**After Set 1:**
> "Understanding complete."

→ If task fully clear, no contract changes needed, no testing needed: Proceed to Task Freeze
→ Otherwise: Continue to Set 2

---

### Set 2: Refinement (If Needed)

**Purpose:** Resolve remaining issues in organized groups.

**Each group may be skipped if no issues were detected.**

Present questions in three sequential groups:

---

**📌 Group 1: Clarification** (if gaps remain)

- Resolve ambiguities from Set 1
- Edge cases needing user input
- Approach selection when multiple valid options
- Flag if task should be split

*Skip if no clarification needed.*

---

**📋 Group 2: Contracts** (if issues detected)

Check task against all loaded contracts with full context from Set 1.

**If conflict found:**
```
⚠️ **Contract Conflict**

Task: [specific step that conflicts]
Conflicts with: [domain].domain.md — "[exact contract text]"

**Options:**
1. **Update task** — [what changes]
2. **Update contract** — [what exception needed]

**Recommendation:** [Option] because [reason]

Choose: [1/2]
```

**If new contract needed** (ONLY for business-critical rules):
```
📋 **Contract Addition**

Task introduces: [critical functionality]

Suggested for [domain].domain.md:
— [Rule — why contract-worthy]

Add? [yes/no]
```

*Skip if no contract issues.*

---

**🧪 Group 3: Testing** (if task affects contracts)

Suggest tests only if task affects contracts or critical behavior.
If user has testing policy in tech-memory.md → follow that, skip question.

```
🧪 **Testing Scope**

This task affects: [contract/critical behavior]

Suggested tests (contract-level):
- [Test: what it verifies]
- [Test: what it verifies]

Excluded (per ai-engineering.md):
- Internal implementation details
- Full unit coverage

Include? [yes/no/modify]
```

*Skip if task doesn't affect contracts.*

---

**After Set 2:**
> "Discovery complete."

→ Proceed to Task Freeze

---

## Question Rules

**Ask ONLY questions affecting:**
- Task definition or intent
- Scope boundaries
- Feasibility or approach
- Required constraints

**Do NOT ask about:**
- Contract compliance (already handled)
- Rules that are already clear
- Implementation details (for planning phase)

**Keep questions high-impact. Skip obvious or low-value questions.**

## Providing Recommendations

**With every decision-based question, provide a brief recommendation:**

**Format:**
```
[Question]

Recommendation: [Suggested option] because [brief reason].
```

**When to recommend:**
- Existing code patterns suggest an approach
- User's constraints favor one option
- One choice is clearly simpler/safer

**When NOT to recommend:**
- Multiple equally valid options
- No clear evidence from code
- User preference needed

**Example (Good):**
```
"Where should password reset tokens be stored?

Recommendation: Database table—follows existing session storage pattern.
Alternative: Redis cache, but adds new dependency."
```

**Example (Avoid - no guidance):**
```
"Where should password reset tokens be stored?
Options: (1) Database, (2) Redis, (3) Memory, (4) File system"
```

**Rules:**
- Keep recommendations 1 sentence
- Ground in code patterns or constraints
- Always allow user to override
- If uncertain, skip recommendation

**Goal:** Every question includes guidance based on evidence.

---

## TASK FREEZE (MANDATORY)

**After discovery complete — execute ALL steps below:**

### 1. Apply Project Updates

**Contract updates:**

Contract files are feature-specific:
- `core.domain.md` - System-wide contracts affecting all features
- `[feature].domain.md` - Contracts for specific feature (auth, payments, etc.)

When adding contracts:
- Add to existing feature file if specific to that feature
- Add to core.domain.md if applies across multiple features
- Create new [feature].domain.md if introducing new feature area

**Tech-memory updates:**
- Add architectural decisions to tech-memory.md
- Include what was chosen and why

Skip if nothing agreed during discovery.

Output: "✓ Project knowledge updated" (if updates made)

---

### 2. Create task.md

Write to `/obelisk/temp-state/task.md`:

```markdown
# Task: [One-line descriptive name]

## Goal
[What must be achieved and why]

## Scope
✓ Included: [clear list from discovery]
✗ Excluded: [clear list from discovery]

## Constraints
- [Contracts to preserve]
- [Technical/business limits]

## Success Criteria
- [Observable completion signals]

## Testing Intent (Optional)
- Required: Yes | No
- Scope:
  - [What to test]
- Excluded:
  - [What not to test]

## Open Questions (if any)
- [Unresolved ambiguities]
```

*Omit Testing Intent section if user declined tests or default policy applies.*

---

### 3. Verify Creation

**MANDATORY:** Confirm `/obelisk/temp-state/task.md` exists.

If NOT → STOP → `"TASK FREEZE FAILED — task.md not created"`

---

### 4. Display Task & Options

**Obelisk: Task Ready**

| | |
|---|---|
| **Task** | [One-line name from header] |
| **Goal** | [One sentence] |
| **Scope** | ✓ [2-3 key inclusions] ✗ [1-2 key exclusions] |
| **Success** | [Primary completion signal] |
| **Testing** | [Yes — N tests / No / Default] |

**Full definition:** `/obelisk/temp-state/task.md`

**Options:**
- `/execute` — Auto-run to completion (plan → implement → review → archive)
- `/plan-task` — Run plan phase only and stop
- `/update-task [changes]` — Modify task definition
- `/abort-task` — Cancel and archive progress

**STOP. Wait for user command.**