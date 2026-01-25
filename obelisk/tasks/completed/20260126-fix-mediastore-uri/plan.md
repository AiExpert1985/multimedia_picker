# Plan: Fix MediaStore URI Conversion for Deletion

## Goal
Fix the "All requested items must be referenced by specific ID" error by converting Document Provider URIs from file_picker to proper MediaStore URIs that work with `MediaStore.createDeleteRequest()`.

## Requirements Coverage
- Files picked from Gallery can be deleted → Steps 1-2
- No "All requested items must be referenced by specific ID" error → Steps 1-2
- Works with both images and videos → Step 1

## Scope

### Files to Modify
- `android/app/src/main/kotlin/.../MainActivity.kt` — Add URI conversion logic before calling `createDeleteRequest()`

### Files to Create
- None

## Execution Steps

1. **Add `convertToMediaStoreUri()` helper function in `MainActivity.kt`**
   - Action: Create a private function that:
     - Checks if URI is a Document Provider URI (authority contains "documents")
     - Uses `DocumentsContract.getDocumentId()` to extract the document ID (e.g., "image:123" or "video:456")
     - Parses the ID to extract the numeric part and media type
     - Builds proper MediaStore URI:
       - Images: `ContentUris.withAppendedId(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, id)`
       - Videos: `ContentUris.withAppendedId(MediaStore.Video.Media.EXTERNAL_CONTENT_URI, id)`
     - Returns original URI if not a Document Provider URI (fallback)
   - Output: Helper function that converts URIs to proper MediaStore format

2. **Update `deleteOriginal()` to use the conversion**
   - Action: Before the Android R+ block that calls `createDeleteRequest()`, convert the URI using the new helper
   - Action: Add logging to show original and converted URIs for debugging
   - Output: Deletion uses the correct MediaStore URI format

3. **Build verification**
   - Action: Run `flutter build apk --debug` to verify no compilation errors
   - Output: Build succeeds

## Acceptance Criteria
- Files picked from Gallery can be deleted after user confirmation
- No "All requested items must be referenced by specific ID" error
- Works with both images and videos

## Must NOT Change
- Contract: Original file MUST NOT be deleted before successful copy verification
- Contract: User MUST explicitly confirm deletion before any file is removed
- Copy flow logic
- Confirmation dialog flow
- File picking logic
