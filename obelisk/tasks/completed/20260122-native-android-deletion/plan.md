# Plan: Implement Native Android Deletion and Storage Check

## Goal
Implement native Android integration to retrieve persistent media URIs, delete original files from the Gallery after copying, and verify storage space, ensuring robust data safety and user confirmation.

## Requirements Coverage
- "Delete Original" removes the file from the Android Gallery/MediaStore → Steps 1, 2, 3
- Copy operation checks for available space → Steps 1, 2
- User is prompted for deletion confirmation → Step 4 (Validation of flow)

## Scope

### Files to Modify
- `android/app/src/main/kotlin/com/example/multimedia_picker/MainActivity.kt` — Implement MethodChannel, storage check, and MediaStore deletion logic.
- `lib/core/services/file_service.dart` — Add native method calls, implement storage check logic.
- `lib/features/picker/providers/picker_provider.dart` — Capture file identifier and pass to delete service.

### Files to Create
- None.

### Files Explicitly Excluded
- None.

## Execution Steps

1. **Implement Native Interface (Android)**
   - Input: `MainActivity.kt` (Basic FlutterActivity)
   - Action: Add `MethodChannel` setup ("com.example.multimedia_picker/media").
   - Action: Implement `getStorageFreeSpace` method using `StatFs` on the external storage directory. Returns bytes (Long).
   - Action: Implement `deleteOriginal` method accepting a URI string.
     - Parse URI.
     - For Android 10+ (Q): Use `MediaStore.createDeleteRequest(contentResolver, listOf(uri))`.
     - Handle `startIntentSenderForResult` for the returned `PendingIntent`.
     - Listen for `onActivityResult` to confirm deletion.
     - Return boolean success/failure to Dart.
   - Output: `MainActivity.kt` with robust native handlers.

2. **Update File Service (Dart)**
   - Input: `lib/core/services/file_service.dart`
   - Action: Add `MethodChannel` ("com.example.multimedia_picker/media").
   - Action: Implement `Future<int> getFreeStorageSpace()`.
   - Action: Update `copyFileToStorage` to first check `getFreeStorageSpace`. If space < file size + buffer (e.g., 10MB), throw "Storage Full" exception.
   - Action: Implement `Future<bool> deleteOriginalFile(String contentUri)` invoking the native method.
   - Output: `file_service.dart` with native capabilities.

3. **Integrate URI Handling in Provider**
   - Input: `lib/features/picker/providers/picker_provider.dart`
   - Action: Update `pickMedia` to capture `file.identifier` (Content URI) into `PickerState`.
   - Action: Update `deleteOriginal` in `PickerNotifier` to pass the captured `identifier` (URI) to `_fileService.deleteOriginalFile`.
   - Output: `picker_provider.dart` passing correct URIs.

4. **Verify & refine Deletion Logic**
   - Input: `lib/features/picker/providers/picker_provider.dart`
   - Action: Ensure the delete call only happens after `copyToStorage` (existing logic).
   - Action: Ensure existing confirmation dialog logic in UI (implicit in task, but verifying flow) is respected.

## Acceptance Criteria
- "Delete Original" functionality removes the file from the Android Gallery/MediaStore (not just the cache).
- Copy operation checks for available space and fails gracefully with a user error message if storage is insufficient.
- User is prompted for deletion confirmation before any deletion occurs.

## Must NOT Change
- Contract: Original file MUST NEVER be deleted before successful copy.
- Contract: Copy is considered "successful" only when file exists in destination.

## Assumptions (Explicitly Accepted in Task)
- `file_picker`'s `identifier` returns a valid Content URI string on Android.
- Android 10+ implementation is sufficient (or fallback provided if easy, but sticking to Task constraint "Android only" implying modern norms).
- The definition of "User is prompted" includes the OS-level "Allow app to delete?" dialog if triggered by `createDeleteRequest`.

## Implementation Preferences (Optional, Non-Binding)
- Use standard `MethodChannel` patterns.
- Keep native code minimal and safe.
