---
description: Auto-execute task through all phases (plan → implement → review → archive)
---

**CURRENT STATE: EXECUTE ORCHESTRATOR**

Run all remaining phases sequentially without user intervention.

> **This is an orchestrator, not a phase.**
> It loads and runs phase prompts in sequence. It does NOT perform phase logic itself.

---

## 1. Input

`/execute` — Run all phases automatically
`/execute-guided` — Pause after each phase for approval

---

## 2. Preflight

**Verify task exists:**
- Check `/obelisk/temp-state/task.md` exists
- If missing → "❌ No task defined. Use `/new-task` first." → STOP

**Detect current phase from file state:**

| Files Present | Current Phase | Next Action |
|---------------|---------------|-------------|
| Only `task.md` | PLANNING | Run /plan |
| `task.md` + `plan.md` | IMPLEMENTATION | Run /implement |
| Above + `implementation-notes.md` | REVIEW | Run /review |
| Above + `review-notes.md` | ARCHIVE | Run /archive |

---

## 3. Execution Loop

```
WHILE not archived:
    1. Detect current phase (from file state)
    2. Load and execute phase prompt
    3. Verify phase output file was created
    4. IF guided mode AND phase complete:
         → Output phase summary
         → "Continue? [yes/no/abort]"
         → Wait for confirmation
    5. IF phase BLOCKED or FAILED:
         → Output error
         → STOP (do not continue to next phase)
    6. Advance to next phase
```

**Phase prompt paths:**
- Planning: `/obelisk/prompts/plan.md`
- Implementation: `/obelisk/prompts/implement.md`
- Review: `/obelisk/prompts/review.md`
- Archive: `/obelisk/prompts/archive.md`

---

## 4. Phase Transition Rules

**Transitions are file-gated, not LLM-decided.**

| Transition | Required File | Required Content |
|------------|---------------|------------------|
| → Planning | `task.md` | Goal, Scope, Success Criteria |
| → Implementation | `plan.md` | Execution Steps, Acceptance Criteria |
| → Review | `implementation-notes.md` | Any content (even "No divergences") |
| → Archive | `review-notes.md` | Status: APPROVED or CHANGES REQUIRED |

**IF required file missing after phase execution:**
→ "❌ EXECUTION HALTED — [phase] failed to produce [file]"
→ STOP

---

## 5. Error Handling

**On STOP condition from any phase:**
- Do NOT attempt recovery
- Do NOT continue to next phase
- Output the phase's error message verbatim
- Suggest: "Run `/abort` to archive progress, or fix the issue and run `/execute` again."

**On CHANGES REQUIRED from review:**
- Archive proceeds normally (task is complete, just not approved)
- Final output notes the status

---

## 6. Output

**During execution (per phase):**
```
⏳ [Phase]: Starting...
✓ [Phase]: Complete → [key output file]
```

**On completion:**
```
✅ TASK EXECUTED

Phases completed: Planning → Implementation → Review → Archive
Final status: [APPROVED | CHANGES REQUIRED]
Archive: /obelisk/tasks/completed/YYYYMMDD-[task-name]/

System ready for next task.
```

**On guided mode, after each phase:**
```
✓ [Phase] complete.

Summary: [2-3 sentence phase outcome]
Output: [file path]

Continue to [next phase]? [yes/no/abort]
```

---

## 7. Critical Rules

1. **DO NOT improvise phase logic** — Load and execute the actual phase prompt
2. **DO NOT skip file verification** — Each phase must produce its output file
3. **DO NOT continue after STOP** — Errors halt the entire chain
4. **DO NOT merge phases** — Each phase runs as a distinct unit
5. **Treat phase prompts as authoritative** — This orchestrator only sequences them

---

## 8. Windsurf/Cascade Integration Note

In Windsurf, this workflow can call sub-workflows:
- "Call /plan" executes the planning workflow
- "Call /implement" executes the implementation workflow
- etc.

The orchestrator's job is sequencing and verification, not reimplementing phase logic.