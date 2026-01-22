# Plan: Multimedia Picker Core Implementation

## Goal
Implement the core file picking and safe storage workflow, including platform permissions and user confirmation for deletion, to enable safe media handling.

## Requirements Coverage
- App requests and receives necessary permissions on launch/use → Step 1, 2
- User can pick an image/video from device → Step 4
- File is copied to app's public storage folder → Step 5
- User is prompted to delete original after successful copy → Step 6
- Original is deleted ONLY if user confirms → Step 6, 7

## Scope

### Files to Modify
- `android/app/src/main/AndroidManifest.xml` — Add storage/media permissions
- `ios/Runner/Info.plist` — Add Photo Library usage descriptions
- `lib/main.dart` — Setup basic routing/home to point to Picker
- `pubspec.yaml` — Verify dependencies (already present, checking versions)

### Files to Create
- `lib/features/picker/ui/picker_screen.dart` — UI with "Pick" button and status
- `lib/features/picker/services/media_service.dart` — Logic for pick, copy, delete
- `lib/features/picker/services/fs_service.dart` — Helper for file system ops (safe copy, naming)

### Files Explicitly Excluded
- None

## Execution Steps

1. **Configure Android Permissions**
   - Input: `android/app/src/main/AndroidManifest.xml`
   - Action: Add `READ_EXTERNAL_STORAGE`, `WRITE_EXTERNAL_STORAGE`, `READ_MEDIA_IMAGES`, `READ_MEDIA_VIDEO`.
   - Output: Manifest with permissions.

2. **Configure iOS Permissions**
   - Input: `ios/Runner/Info.plist`
   - Action: Add `NSPhotoLibraryUsageDescription` key/value.
   - Output: Plist with usage description.

3. **Create Basic Feature Structure**
   - Input: None
   - Action: Create `lib/features/picker/ui` and `lib/features/picker/services` directories.
   - Output: Directory structure.

4. **Implement File System Service**
   - Input: New file `lib/features/picker/services/fs_service.dart`
   - Action: Implement `safeCopy(File source, Directory targetDir)` logic.
     - Check target existence.
     - Implement duplicate naming logic (`file(1).ext`).
     - Copy file.
     - Verify existence after copy.
   - Output: Robust file copy utility.

5. **Implement Media Service**
   - Input: New file `lib/features/picker/services/media_service.dart`
   - Action: Implement functions:
     - `pickMedia()`: Call `FilePicker.platform.pickFiles(type: FileType.media)`.
     - `processMedia(PlatformFile pickedFile)`:
       - Get copy destination (`getApplicationDocumentsDirectory` or external).
       - Call `fs_service.safeCopy`.
       - Return result (success/path).
     - `deleteOriginal(String originalPath)`:
       - Call `File(originalPath).delete()`.
   - Output: Service handling business logic.

6. **Implement Picker UI**
   - Input: New file `lib/features/picker/ui/picker_screen.dart`
   - Action: Create Screen with:
     - "Pick Media" button.
     - On pick -> Call `MediaService.processMedia`.
     - On success -> Show `AlertDialog` ("Delete Original?").
     - On confirm -> Call `MediaService.deleteOriginal`.
     - Show SnackBar on success/error.
   - Output: Interactive UI.

7. **Wire Navigation**
   - Input: `lib/main.dart`
   - Action: Update `GoRouter` or `home` widget to show `PickerScreen`.
   - Output: App launches to picker.

## Acceptance Criteria
- App requests and receives necessary permissions on launch/use
- User can pick an image/video from device
- File is copied to app's public storage folder
- User is prompted to delete original after successful copy
- Original is deleted ONLY if user confirms

## Must NOT Change
- Domain Contract: Original file MUST NEVER be deleted before successful copy
- Domain Contract: User MUST explicitly confirm deletion
- Existing unrelated code (if any)

## Assumptions (Explicitly Accepted in Task)
- Using `file_picker` package is sufficient for picking.
- `File(path).delete()` handling is sufficient for "Original is deleted"; if platform restricts this (cached files), we handle the error via SnackBar as per contract.
