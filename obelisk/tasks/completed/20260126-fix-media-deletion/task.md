# Task: Fix Media Deletion Failure on Android

## Goal
Fix the "Deletion Failed: Exception: Failed to delete original file" error that occurs after copying media files. The app should successfully delete original files from the device Gallery/MediaStore after the user confirms deletion.

## Scope
✓ Included:
- Debug why `deleteOriginalFile` returns `false` on Android 14+
- Fix the native Kotlin deletion logic in `MainActivity.kt`
- Ensure `file.identifier` (content URI) from `file_picker` is correctly handled
- **Add descriptive error messages** that explain the specific reason for deletion failure (e.g., "Permission denied", "File not found in MediaStore", "URI format invalid")
- Test fix with both images and videos

✗ Excluded:
- iOS implementation (future task)
- Changes to the copy or confirmation flow
- UI modifications (beyond error message text)

## Constraints
- Contract: Original file MUST NOT be deleted before successful copy verification (preserved)
- Contract: User MUST explicitly confirm deletion before any file is removed (preserved)
- Must work on Android 10+ (Scoped Storage / MediaStore APIs)
- Must handle both Gallery-sourced and file system-sourced media

## Implementation Preferences
- Use `MediaStore.createDeleteRequest()` for Android R+ (11+)
- Handle `RecoverableSecurityException` for Android Q (10)
- Add debug logging to identify exact failure point

## Success Criteria
- User can pick an image or video from Gallery
- After copy and confirmation, the original file is deleted from the device
- No "Deletion Failed" error message appears on successful deletion
- **If deletion fails, error message explains WHY** (not just "Failed to delete")
- Works on Android 14 (latest)

## Open Questions
- None.
