---

# Tech Memory

Technical decisions that cannot be reliably inferred from code.

**Last Updated:** 2026-01-22

---

## Stack Choices

**Framework:** Flutter
- **Why:** Cross-platform support for Android and iOS with single codebase
- **Target Platforms:** Android (current), iOS (future)

**Storage Location:** App's public storage
- **Why:** Files need to be accessible to other apps and the user
- **Not:** App's private storage

---

## Technical Constraints

**Copy Verification Method:** File existence check
- **Why:** Minimalist approach - verify file exists in destination
- **Not:** Hash verification, content verification, or size matching

**Duplicate Handling:** Append number to filename
- **Why:** Never overwrite existing files, preserve both versions
- **Pattern:** `filename.ext` → `filename(1).ext` → `filename(2).ext`

**Error Notification:**
- Deletion failures: Snackbar
- Storage full errors: Error dialog

---

## Design Principles

- Minimal UI
- Minimal code
- Cross-platform libraries/code preferred (Android + iOS compatibility)

---

## Commands

(To be added as project develops)

---

**Authority:** This file records technical decisions. It does NOT override domain contracts.
