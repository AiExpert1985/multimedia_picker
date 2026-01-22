# Task: Implement Native Android Deletion and Storage Check

## Goal
Implement native Android integration to retrieve persistent media URIs, delete original files from the Gallery after copying, and verify storage space, ensuring robust data safety and user confirmation.

## Scope
✓ Included:
- Modify `MainActivity.kt` to handle MethodChannel calls for `deleteOriginal` (via MediaStore) and `checkStorage`.
- Update `FileService` / `MediaService` to invoke native methods.
- Investigate and fix retrieving the persistent content URI (likely via `file_picker` identifier or switching to native picker if needed).
- Implement "Storage Full" check before copying.

✗ Excluded:
- iOS implementation (future).
- Cloud storage or backup.

## Constraints
- **Safety Critical:** MUST verify file copy exists in destination before attempting deletion.
- **Safety Critical:** MUST NOT delete original if copy operation fails.
- Target Platform: Android only (for this task).
- Existing UI: Use existing confirmation dialogs and snackbars where possible.

## Implementation Preferences
- Use Flutter's `MethodChannel` for communication with native Android code.
- Use `MediaStore` API for deletion on Android 10+ (Scoped Storage).
- Use `StatFs` for storage space checking.

## Success Criteria
- "Delete Original" functionality removes the file from the Android Gallery/MediaStore (not just the cache).
- Copy operation checks for available space and fails gracefully with a user error message if storage is insufficient.
- User is prompted for deletion confirmation before any deletion occurs.

## Open Questions
- None.
