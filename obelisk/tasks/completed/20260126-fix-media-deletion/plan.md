# Plan: Fix Media Deletion Failure on Android

## Goal
Fix the "Deletion Failed: Exception: Failed to delete original file" error that occurs after copying media files. The app should successfully delete original files from the device Gallery/MediaStore after the user confirms deletion.

## Requirements Coverage
- User can pick an image or video from Gallery → Pre-existing (verified working)
- After copy and confirmation, original file is deleted → Steps 1-3
- No "Deletion Failed" error on successful deletion → Steps 1-3
- If deletion fails, error message explains WHY → Step 4
- Works on Android 14 (latest) → Steps 1-3

## Scope

### Files to Modify
- `android/app/src/main/kotlin/.../MainActivity.kt` — Fix deletion logic, add detailed error reporting
- `lib/core/services/file_service.dart` — Parse error codes from native, propagate descriptive messages
- `lib/features/picker/services/media_service.dart` — Propagate error messages (minor)

### Files to Create
- None

## Execution Steps

1. **Fix `MainActivity.kt` deletion logic**
   - Action: Refactor `deleteOriginal()` to ALWAYS use `MediaStore.createDeleteRequest()` on Android R+ (11+) as the primary method, since apps do not own gallery files
   - Action: Remove the attempt to call `contentResolver.delete()` first on Android R+, as it will always fail for files we don't own
   - Action: For Android Q (10), keep the `RecoverableSecurityException` handling
   - Output: Native deletion uses the correct API path for each Android version

2. **Add detailed error codes in `MainActivity.kt`**
   - Action: Return structured error information (not just `true`/`false`) including:
     - `URI_INVALID` — URI could not be parsed
     - `FILE_NOT_FOUND` — No MediaStore entry for this URI
     - `PERMISSION_DENIED` — User rejected deletion prompt
     - `USER_CANCELLED` — User cancelled the deletion dialog
     - `UNKNOWN_ERROR` — Catch-all with exception message
   - Output: Native channel returns descriptive error strings

3. **Update `file_service.dart` to handle error responses**
   - Action: Change `deleteOriginalFile()` to parse the native response:
     - If `true`, return success
     - If error string, throw Exception with the descriptive message
   - Output: Dart side throws descriptive exceptions on failure

4. **Verify error message propagation**
   - Action: Ensure `media_service.dart` passes through the exception message from `file_service.dart`
   - Action: Confirm `picker_screen.dart` displays the full error message (already does via `$e`)
   - Output: User sees descriptive error like "Deletion failed: Permission denied by user"

5. **Build verification**
   - Action: Run `flutter build apk --debug` to verify no compilation errors
   - Output: Build succeeds

## Acceptance Criteria
- User can pick an image or video from Gallery
- After copy and confirmation, the original file is deleted from the device
- No "Deletion Failed" error message appears on successful deletion
- If deletion fails, error message explains WHY (not just "Failed to delete")
- Works on Android 14 (latest)

## Must NOT Change
- Contract: Original file MUST NOT be deleted before successful copy verification
- Contract: User MUST explicitly confirm deletion before any file is removed
- Contract: If deletion fails after copy, user MUST be warned via snackbar
- Copy flow logic
- Confirmation dialog flow
