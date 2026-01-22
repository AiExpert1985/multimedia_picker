# Obelisk Workflow Aliases

Quick commands for Obelisk phases in Antigravity/Claude.ai.

## Project Setup
- `@new-project` → Load and execute project discovery
- `@initialize` → Load and execute project initialization

## Task Workflow
- `@new-task` → Load and execute task discovery
- `@plan` → Load task freeze, then planning
- `@fast-path` → Execute freeze → plan → implement → review → archive
- `@implement` → Load and execute implementation
- `@review` → Load and execute review
- `@close` → Archive task and cleanup

## Utilities
- `@abort` → Abort current task and archive progress
- `@suggest` → Suggest next tasks based on backlog

---

**Implementation:**

When user types a command above:
1. Load the corresponding prompt from `/obelisk/prompts/`
2. Execute it exactly as specified in the prompt
3. Do NOT add interpretation or modification

**Command Mapping:**
- `@new-project` → `01-project-discovery-prompt.md`
- `@initialize` → `02-project-initialization-prompt.md`
- `@new-task` → `03-task-discovery-prompt.md`
- `@plan` → `04-task-freeze-prompt.md` then `05-task-planning-prompt.md`
- `@fast-path` → `fast-path-prompt.md`
- `@implement` → `06-task-implementation-prompt.md`
- `@review` → `07-task-review-prompt.md`
- `@close` → `08-archive-and-cleanup-prompt.md`
- `@abort` → `abort-task-prompt.md`
- `@suggest` → `task-suggestion-prompt.md`