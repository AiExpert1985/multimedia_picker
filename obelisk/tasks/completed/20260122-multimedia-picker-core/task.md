# Task: Multimedia Picker Core Implementation

## Goal
Implement the core file picking and safe storage workflow, including platform permissions and user confirmation for deletion, to enable safe media handling.

## Scope
✓ Included:
- Configure Android permissions (`AndroidManifest.xml`) and iOS keys (`Info.plist`)
- Implement File Picker UI using `file_picker` package
- Implement "Safe Copy" logic: Pick -> Copy to App Storage -> Verify -> Prompt -> Delete Original
- Handle duplicate filenames (append counter)

✗ Excluded:
- Production-ready features (cloud sync, undo)
- Media metadata editing
- Native gallery non-picker integrations

## Constraints
- Must use `file_picker` package
- Verification via file existence check
- No overwriting existing files
- Domain Contract: Original file MUST NEVER be deleted before successful copy to app folder
- Domain Contract: User MUST explicitly confirm deletion before any file is removed

## Implementation Preferences (if any)
- None specified during discovery (use tech memory defaults: Riverpod, GoRouter)

## Success Criteria
- App requests and receives necessary permissions on launch/use
- User can pick an image/video from device
- File is copied to app's public storage folder
- User is prompted to delete original after successful copy
- Original is deleted ONLY if user confirms

## Open Questions (if any)
- None
