# Task: Fix MediaStore URI Conversion for Deletion

## Goal
Fix the "All requested items must be referenced by specific ID" error by converting Document Provider URIs from file_picker to proper MediaStore URIs that work with `MediaStore.createDeleteRequest()`.

## Scope
✓ Included:
- Convert Document Provider URIs (e.g., `content://com.android.providers.media.documents/...`) to MediaStore URIs (e.g., `content://media/external/images/media/<ID>`)
- Handle both image and video URIs
- Add descriptive error message if conversion fails

✗ Excluded:
- iOS implementation
- Changes to copy or confirmation flow
- Any changes to file picking logic

## Constraints
- Contract: Original file MUST NOT be deleted before successful copy verification (preserved)
- Contract: User MUST explicitly confirm deletion before any file is removed (preserved)
- Must work on Android 11+ (R+) with Scoped Storage

## Implementation Preferences
- Extract document ID from Document Provider URI using DocumentsContract
- Build proper MediaStore content URI using the extracted ID
- Detect media type (image/video) from URI authority or path

## Success Criteria
- Files picked from Gallery can be deleted after user confirmation
- No "All requested items must be referenced by specific ID" error
- Works with both images and videos

## Open Questions
- None.
