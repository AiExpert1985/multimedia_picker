import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

/// Service for file operations: copy, verify, delete
class FileService {
  static const platform = MethodChannel('com.example.multimedia_picker/media');

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

  /// Gets available free storage space in bytes
  Future<int> getFreeStorageSpace() async {
    try {
      final int freeSpace = await platform.invokeMethod('getStorageFreeSpace');
      return freeSpace;
    } on PlatformException catch (e) {
      print("Failed to get storage space: '${e.message}'.");
      return 0;
    }
  }

  /// Copies a file to the app's storage directory
  /// Returns the destination path if successful
  /// Handles duplicates by appending a number: file.ext -> file(1).ext
  Future<String> copyFileToStorage(String sourcePath) async {
    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      throw Exception('Source file does not exist');
    }

    // Check storage space (Buffer of 10MB)
    final fileSize = await sourceFile.length();
    final freeSpace = await getFreeStorageSpace();
    if (freeSpace < fileSize + (10 * 1024 * 1024)) {
      throw Exception('Insufficient storage space');
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

  /// Deletes the original file via native platform channel
  /// Returns true if deletion was successful
  /// Throws Exception with descriptive message on failure
  Future<bool> deleteOriginalFile(String filePath) async {
    try {
      // Use native deletion for MediaStore/Gallery files
      final bool? result = await platform.invokeMethod('deleteOriginal', {
        'uri': filePath,
      });
      if (result == true) {
        return true;
      }
      // Native returned false without throwing - shouldn't happen with new code
      throw Exception('Deletion failed: Unknown error');
    } on PlatformException catch (e) {
      // Native code threw an error with descriptive message
      // Error codes: URI_INVALID, FILE_NOT_FOUND, PERMISSION_DENIED, USER_CANCELLED, DELETE_FAILED
      final errorMessage = _getReadableErrorMessage(e.code, e.message);
      throw Exception(errorMessage);
    } catch (e) {
      // Re-throw if already an Exception, otherwise wrap
      if (e is Exception) rethrow;
      throw Exception('Deletion failed: $e');
    }
  }

  /// Converts error codes to user-friendly messages
  String _getReadableErrorMessage(String code, String? message) {
    switch (code) {
      case 'URI_INVALID':
        return 'Invalid file reference: ${message ?? "The file URI is malformed"}';
      case 'FILE_NOT_FOUND':
        return 'File not found: ${message ?? "The file may have already been deleted"}';
      case 'PERMISSION_DENIED':
        return 'Permission denied: ${message ?? "Unable to delete this file"}';
      case 'USER_CANCELLED':
        return 'Deletion cancelled by user';
      case 'DELETE_FAILED':
        return 'Deletion failed: ${message ?? "Unknown error occurred"}';
      default:
        return message ?? 'Deletion failed: $code';
    }
  }
}
