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

## Contract Validation (After Reconnaissance)

**Internal analysis (silent):**
- Check task against all loaded contracts
- Identify conflicts (blocking)
- Identify missing contracts (optional)

**Output to user ONLY if action needed:**

### No Issues
→ Continue silently to Discovery Questions

---

### Contract Conflict Detected
```
⚠️ **Contract Conflict**

Task: [specific step that conflicts]
Conflicts with: [domain].domain.md - "[exact contract text]"

**Options:**

1. **Update task** - [Brief: what would change in task to comply]
   Example: "Remove guest checkout, require login"

2. **Update contract** - [Brief: what exception/change needed]
   Example: "Add exception: guest checkout allowed for /api/checkout endpoint"

**Recommendation:** [Option X] because [brief reason based on context]
Example: "Option 1—preserves security contract, simpler implementation"

Choose: [1/2]
```

Continue based on choice.

**Based on user's choice, adjust understanding and continue to Discovery Questions.**

---

```markdown
### Missing Contracts Detected

**Suggest ONLY for:**
- Business-critical rules (security, data integrity, compliance)
- System-wide invariants
- Permanent architectural constraints

**NOT for:**
- Implementation details
- Task-specific logic
- Obvious rules

**If needed:**

```
📋 **Contract Addition**

Task introduces: [critical functionality]

Suggested for [domain].domain.md:
- [Rule - why contract-worthy]

Add? [yes/no]
```

**High bar: Only contracts future tasks MUST respect.**
```

**Note user's response and continue to Discovery Questions.**

---

**All approved changes will be applied during Task Freeze.**

---

## Discovery Questions

**After Contract Validation:**

### Immediate Convergence (Optional)

Skip questions if ALL true:
- Task clear (intent, scope, success criteria explicit)
- No contract conflicts (or already resolved)
- No architectural concerns
- No significant ambiguities

→ Proceed directly to Task Freeze

### Discovery Discussion (If Needed)

**Phase 1: Initial Understanding**
- What, why, for whom
- Success criteria (observable completion signals)
- Scope boundaries (what's in/out)
- Key constraints or dependencies

**Phase 2: Refinement (only if needed)**
- Resolve ambiguities
- Surface risks or contract conflicts
- Flag if task should be split
- Clarify approach when multiple valid options

**After clarification, proceed to Task Freeze.**

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

**With EVERY question, provide a brief recommendation:**

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

**CURRENT STATE: TASK FREEZE**

Freeze intent, and prepare for execution.

**After discovery questions complete (or immediate convergence):**

### 1. Project Knowledge Updates

**Execute approved updates from validation/discovery:**

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
- Add decisions to tech-memory.md

Skip if nothing agreed during discovery.

**Tech-memory updates:**
- Add any architectural decisions made during discussion
- Include what was chosen and why

**If nothing to update, skip to step 2.**

Output: "✓ Project knowledge updated" (if updates made)

---

### 2. Present Summary

Display task summary for final review:
```markdown
**Task Summary:**

**Intent:** [One sentence: what and why]

**Scope:**
✓ [Included item 1]
✓ [Included item 2]
✗ [Excluded item 1]
✗ [Excluded item 2]

**Success Criteria:**
- [Observable signal 1]
- [Observable signal 2]

**Constraints:**
- [Contract/limit 1]
- [Contract/limit 2]

**Open Questions (if any):**
- [Unresolved item 1]
```

**Proceed to create task.md? [yes/corrections]**

**If "corrections":**
- User provides feedback
- Update understanding
- Re-present summary
- Repeat until approved

**If "yes":**
- Proceed to step 2 (Create task.md)

---

### 3. Create task.md

Write to `/obelisk/temp-state/task.md`:
```markdown
# Task: [One-line descriptive name]

## Goal
[What must be achieved and why - from summary]

## Scope
✓ Included: [from summary]
✗ Excluded: [from summary]

## Constraints
- [Contracts to preserve - from summary]
- [Technical/business limits - from summary]

## Success Criteria
- [Observable completion signals - from summary]

## Open Questions (if any)
- [Unresolved ambiguities - from summary]
```

### 4. Verify Creation

**MANDATORY:** Confirm `/obelisk/temp-state/task.md` exists.

If NOT → STOP → `"TASK FREEZE FAILED — task.md not created"`

### 5. Display Task & Options
```
**Task Defined:** /obelisk/temp-state/task.md

[Display complete task.md contents inline]

**Options:**
`/execute` — Auto-run to completion (plan → implement → review → archive)
`/execute-guided` — Stop at plan and review for approval
`/update-task [changes]` — Modify task definition
`/abort` — Cancel and archive progress
```

**STOP. Wait for user command.**

**If user provides corrections instead of command:**
Treat as implicit `/update-task` request.