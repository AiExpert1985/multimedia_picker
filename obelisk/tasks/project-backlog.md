---

# Project Backlog: Multimedia Picker

---

## System Requirements

### Core Functionality

1. **File Picker**
   - Pick images or videos from anywhere on device
   - Support both Android and iOS platforms

2. **Copy Operation**
   - Copy selected file to app's public storage
   - Verify file exists in destination before proceeding
   - Handle storage full scenario with error message

3. **Duplicate Handling**
   - Check if filename exists in destination
   - Append number to filename if duplicate: `filename(1).ext`, `filename(2).ext`, etc.

4. **Deletion Confirmation**
   - Show confirmation dialog to user before deletion
   - Only proceed with deletion after explicit user confirmation
   - Never delete if copy was not successful

5. **Deletion Operation**
   - Delete original file only after successful copy
   - Show snackbar warning if deletion fails
   - Keep copied file even if deletion fails

6. **Error Handling**
   - Storage full: Show error, do not copy or delete
   - Deletion failure: Show snackbar warning

### UI Requirements

- Minimal UI design
- Snackbar for deletion failure warnings
- Error dialog for storage full
- Confirmation dialog for deletion

---

## Remaining Tasks

1. Set up Flutter project structure
2. Add required permissions for file access (Android/iOS)
3. Implement file picker functionality
4. Implement copy to app's public storage
5. Implement file existence verification
6. Implement duplicate filename handling
7. Implement deletion confirmation dialog
8. Implement deletion functionality
9. Implement error handling (storage full, deletion failure)
10. Test on Android device
11. Test on iOS device (when ready)

---

> This file is for human reference only and has NO authority.
> Only contracts, frozen tasks, and code define system behavior.
