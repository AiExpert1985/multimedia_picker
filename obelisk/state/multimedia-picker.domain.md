---

# Domain Contract: Multimedia Picker

**Version:** 1.0
**Created:** 2026-01-22

---

## System Identity

**What it is:**
- A Flutter-based multimedia picker app that copies images/videos to the app's public storage and deletes the original files after user confirmation

**What it is NOT:**
- Not a gallery app
- Not a media organizer
- Not a production app (testing/learning tool only)

**For whom:**
- Developer (you) for testing functionality
- To be integrated into other apps later

**Core promise:**
- Safe file relocation: copy first, delete only after confirmation and successful copy

---

## Business Invariants

These rules MUST always hold:

1. Original file MUST NEVER be deleted before successful copy to app folder
2. Copy is considered "successful" only when file exists in destination
3. User MUST explicitly confirm deletion before any file is removed
4. If deletion fails after copy, user MUST be warned via snackbar
5. If storage is full, MUST show error and MUST NOT copy or delete
6. If file with same name exists in destination, MUST rename with appended number (never overwrite)
7. App MUST be able to pick any image/video from device regardless of location

---

## Safety-Critical Rules

1. **Delete-After-Copy Order:** Deletion MUST occur only after successful copy verification
2. **User Confirmation Required:** No automatic deletion without explicit user consent
3. **Irreversible Data Loss Prevention:** Never delete original if copy cannot be verified

---

## Explicit Non-Goals

- Production-ready features (recovery, undo, backup)
- Complex media organization or metadata handling
- Cloud sync or external storage
- Performance optimization for large files
- Advanced error recovery mechanisms

---

## Open Questions

None.

---

**Authority:** This file defines business truth. Lower layers (tasks, plans, code) must comply.
