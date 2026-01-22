# Plan: Implement Multimedia Picker with File Relocation

## Goal
Replace the default Flutter counter app with a minimal multimedia picker that allows users to select images/videos, copies them to the app's public storage, and deletes the original files after explicit user confirmation.

## Requirements Coverage
- Button opens file picker allowing image/video selection → Step 3, 4
- Selected file is copied to app's public storage folder → Step 5
- Copy success verified by file existence check → Step 5
- Confirmation dialog appears after successful copy → Step 6
- On confirmation, original file is deleted → Step 6
- Status text displays success/failure for both copy and deletion → Step 4, 5, 6
- Deletion failure shows snackbar notification → Step 6

## Scope

### Files to Modify
- `pubspec.yaml` — Add dependencies: file_picker, flutter_riverpod, go_router, path_provider
- `lib/main.dart` — Replace counter app with minimal picker UI and Riverpod/GoRouter setup

### Files to Create
- `lib/core/services/file_service.dart` — File operations: copy with duplicate handling, delete, verify
- `lib/features/picker/providers/picker_provider.dart` — Riverpod state management for picker
- `lib/features/picker/ui/picker_screen.dart` — Minimal UI: button + status text
- `lib/features/picker/ui/widgets/delete_confirmation_dialog.dart` — Confirmation dialog
- `lib/router.dart` — GoRouter configuration

### Files Explicitly Excluded
- `obelisk/state/*.domain.md` — Contract files, read-only
- `obelisk/state/tech-memory.md` — Read-only during execution
- iOS-specific configuration files — Out of scope for current implementation

## Execution Steps

### Step 1: Update Dependencies
- Input: Current `pubspec.yaml` with only flutter core dependencies
- Action: Add dependencies:
  - `file_picker: ^10.3.8`
  - `flutter_riverpod: ^3.2.0`
  - `go_router: ^17.0.1`
  - `path_provider: ^2.1.5`
- Output: Updated `pubspec.yaml` with new dependencies

### Step 2: Run flutter pub get
- Input: Updated `pubspec.yaml`
- Action: Execute `flutter pub get` to install dependencies
- Output: Dependencies installed, `.dart_tool` updated

### Step 3: Create File Service
- Input: None (new file)
- Action: Create `lib/core/services/file_service.dart` with:
  - `getStorageDirectory()` — Returns app's public storage path using path_provider
  - `copyFileToStorage(String sourcePath, String fileName)` — Copies file, handles duplicates by appending number
  - `verifyFileCopy(String destinationPath)` — Returns true if file exists
  - `deleteOriginalFile(String filePath)` — Deletes source file, returns success/failure
- Output: File service with all file operations

### Step 4: Create Picker Provider (Riverpod 3.0+)
- Input: None (new file)
- Action: Create `lib/features/picker/providers/picker_provider.dart` with:
  - State class holding: `isLoading`, `statusMessage`, `pickedFilePath`, `copiedFilePath`
  - Provider using Riverpod 3.x patterns (Notifier/AsyncNotifier)
  - Methods: `pickMedia()`, `copyToStorage()`, `deleteOriginal()`
- Output: Riverpod provider managing picker state

### Step 5: Create Picker Screen UI
- Input: None (new file)
- Action: Create `lib/features/picker/ui/picker_screen.dart` with:
  - Minimal UI: centered column layout
  - Status text widget showing current state/result
  - Single button to trigger file picker (image/video types)
  - ConsumerWidget for Riverpod integration
- Output: Minimal picker screen

### Step 6: Create Delete Confirmation Dialog
- Input: None (new file)
- Action: Create `lib/features/picker/ui/widgets/delete_confirmation_dialog.dart` with:
  - AlertDialog with "Delete original file?" message
  - Yes/No buttons
  - Returns boolean result
- Output: Reusable confirmation dialog

### Step 7: Create Router Configuration
- Input: None (new file)
- Action: Create `lib/router.dart` with:
  - GoRouter instance with single route to PickerScreen
  - Initial location: `/`
- Output: GoRouter configuration

### Step 8: Update main.dart
- Input: Current counter app code
- Action: Replace entirely with:
  - ProviderScope wrapper
  - MaterialApp.router with GoRouter
  - Basic theme setup
  - Remove all counter-related code
- Output: Clean entry point with Riverpod + GoRouter

### Step 9: Verify Build
- Input: Complete implementation
- Action: Run `flutter build apk --debug` or `flutter analyze`
- Output: Successful build/analysis with no errors

## Acceptance Criteria
- Button opens file picker allowing image/video selection
- Selected file is copied to app's public storage folder
- Copy success verified by file existence check
- Confirmation dialog appears after successful copy
- On confirmation, original file is deleted
- Status text displays success/failure for both copy and deletion
- Deletion failure shows snackbar notification

## Must NOT Change
- `/obelisk/state/multimedia-picker.domain.md` — Business invariants
- `/obelisk/state/tech-memory.md` — Technical decisions
- Delete order: Copy MUST succeed before deletion is offered

## Assumptions (Explicitly Accepted in Task)
- Android-only testing for now (iOS structure included but not tested)
- Single file selection (not multiple)
- File existence check is sufficient for copy verification
- App's public storage accessed via path_provider external storage directory

## Implementation Preferences (Optional, Non-Binding)
- Use `file_picker: ^10.3.8` for cross-platform file selection
- Use `path_provider: ^2.1.5` for storage path resolution
- Use `flutter_riverpod: ^3.2.0` with Notifier pattern (not legacy StateNotifier)
- Use `go_router: ^17.0.1` for navigation
- FileType.media for picking both images and videos
- Snackbar for deletion failures, simple text for status updates
