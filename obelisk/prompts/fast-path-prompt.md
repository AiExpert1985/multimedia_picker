
---

**CURRENT STATE: FAST PATH EXECUTION**

Automatically execute the remaining Obelisk task workflow in sequence without showing user prompts or waiting for user input

---

## Execution Mode

This is a **non-interactive execution mode**.

- Do NOT display user instructions even if the loaded prompt has user input request
- Do NOT wait for user input
- Do NOT branch on user responses
- Execute prompts sequentially

---

## Execution Order (MANDATORY)

Execute the following prompts **in order**, stopping immediately if any prompt blocks, aborts, or fails:

1. `/obelisk/prompts/04-task-freeze-prompt.md`
2. `/obelisk/prompts/06-task-implementation-prompt.md`
3. `/obelisk/prompts/07-task-review-prompt.md`

---

## Rules

- Do NOT skip, reorder, or merge steps
- Respect STOP and ABORT semantics inside each prompt
- If any prompt outputs BLOCKED or ABORTED → stop chaining immediately
- Do NOT reinterpret outputs between prompts
- Do NOT introduce new decisions

---

## Final Output

If all steps complete successfully, output exactly:

FAST PATH COMPLETE — TASK ARCHIVED

css
Copy code

STOP.