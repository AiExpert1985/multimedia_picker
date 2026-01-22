
---

# AI Engineering Guidelines

Execution constraints for code quality, architecture, security, and research.

**Respected during Planning. Enforced during Implementation and Review.**

---

## Code Quality

- Simple over clever
- Junior-readable naming and flow
- Single responsibility: one reason to change per function/class (~20–30 lines)
- Early returns; avoid deep nesting
- Fail fast; no silent failures
- Preserve valid comments
- Write test-ready code (no tests unless plan requires)

---

## Structure & Architecture

**Organization:**
- Feature-first structure: group by business capability, not technical layers
- Separate features into distinct modules/folders
- Follow existing project patterns where they exist

**Feature Boundaries:**
- Inter-feature access through public service/provider interfaces only
- Shared domain models/repositories allowed only when explicitly designed as shared
- Feature internals are private by default

**Abstraction:**
- Introduce abstractions when they improve testability, debuggability, or separation of responsibility
- Design for extensibility at integration boundaries (APIs, databases, external services)
- Avoid speculative or future-proof abstractions
- Use dependency injection; no hard-coded dependencies

**Internationalization:**
- Design with i18n in mind (EN/AR, LTR/RTL)

---

## Libraries & Research

**When using external libraries:**
- You MUST verify latest stable version and current API patterns via online sources
- Do NOT rely on model training data or memory
- Consult official documentation for recommended usage
- If uncertain about API correctness, flag explicitly in implementation notes

**Flutter-specific requirements:**
- Use Riverpod 3.0+ (NOT 2.x or legacy)
- Follow Riverpod 3.x recommendations and patterns (do NOT use legacy classes or APIs)
- Use GoRouter for navigation
- Verify current API patterns for both libraries before use

**Research required for:**
- Any new dependency
- Unfamiliar or deprecated APIs
- Non-obvious integration patterns

**Documentation:**
- Log library version, source, and justification in implementation notes

---

## Security & Dependencies

**MUST NOT:**
- Introduce security vulnerabilities
- Hard-code secrets or credentials
- Add dependencies unless plan requires

**MUST:**
- Sanitize all inputs
- Use environment variables for credentials
- Verify dependency compatibility before use
- Flag security risks explicitly in implementation notes