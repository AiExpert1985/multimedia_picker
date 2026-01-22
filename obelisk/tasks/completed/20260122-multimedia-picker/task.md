# Task: Implement Multimedia Picker with File Relocation

## Goal
Replace the default Flutter counter app with a minimal multimedia picker that allows users to select images/videos, copies them to the app's public storage, and deletes the original files after explicit user confirmation.

## Scope
✓ Included:
- Remove default counter app UI and logic from main.dart
- Add cross-platform file picker library (Android-ready, iOS-compatible for future)
- Implement file copy to app's public storage folder
- Implement original file deletion with user confirmation dialog
- Minimal UI: one button to pick files, status text showing pick and deletion results
- Handle duplicate filenames with appended numbers

✗ Excluded:
- iOS implementation/testing (only structure for future compatibility)
- Media preview or gallery features
- Advanced error recovery mechanisms
- Multiple file selection in one operation
- Cloud sync or external storage

## Constraints
- Contract: Original file MUST NOT be deleted before successful copy verification
- Contract: User MUST explicitly confirm deletion before any file is removed
- Contract: Deletion failures MUST show snackbar warning
- Contract: Storage full errors MUST show error dialog and prevent copy/delete
- Contract: Duplicate filenames MUST be renamed with appended number (never overwrite)
- Tech-memory: Use Riverpod 3.0+ for state management
- Tech-memory: Use GoRouter for navigation
- Tech-memory: Files stored in app's public storage (accessible to other apps)

## Implementation Preferences (if any)
- Use `file_picker` package for cross-platform multimedia selection
- Use `path_provider` for storage path resolution
- Minimal dependencies, simple code structure

## Success Criteria
- Button opens file picker allowing image/video selection
- Selected file is copied to app's public storage folder
- Copy success verified by file existence check
- Confirmation dialog appears after successful copy
- On confirmation, original file is deleted
- Status text displays success/failure for both copy and deletion
- Deletion failure shows snackbar notification

## Open Questions (if any)
- None
