import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Service for file operations: copy, verify, delete
class FileService {
  /// Gets the app's external storage directory for storing media
  Future<Directory> getStorageDirectory() async {
    // Use external storage for public access
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('External storage not available');
    }

    // Create a subdirectory for our media files
    final mediaDir = Directory('${directory.path}/MediaPicker');
    if (!await mediaDir.exists()) {
      await mediaDir.create(recursive: true);
    }

    return mediaDir;
  }

  /// Copies a file to the app's storage directory
  /// Returns the destination path if successful
  /// Handles duplicates by appending a number: file.ext -> file(1).ext
  Future<String> copyFileToStorage(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist');
    }

    final storageDir = await getStorageDirectory();
    final fileName = sourceFile.uri.pathSegments.last;

    // Handle duplicate filenames
    String destinationPath = '${storageDir.path}/$fileName';
    destinationPath = await _getUniqueFilePath(destinationPath);

    // Copy the file
    await sourceFile.copy(destinationPath);

    return destinationPath;
  }

  /// Returns a unique file path by appending a number if file exists
  /// Example: file.ext -> file(1).ext -> file(2).ext
  Future<String> _getUniqueFilePath(String originalPath) async {
    String path = originalPath;
    int counter = 0;

    while (await File(path).exists()) {
      counter++;
      final lastDot = originalPath.lastIndexOf('.');
      if (lastDot != -1) {
        // Has extension: insert number before extension
        path =
            '${originalPath.substring(0, lastDot)}($counter)${originalPath.substring(lastDot)}';
      } else {
        // No extension: append number at end
        path = '$originalPath($counter)';
      }
    }

    return path;
  }

  /// Verifies that a file copy was successful by checking existence
  Future<bool> verifyFileCopy(String destinationPath) async {
    final file = File(destinationPath);
    return await file.exists();
  }

  /// Deletes the original file
  /// Returns true if deletion was successful, false otherwise
  Future<bool> deleteOriginalFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
