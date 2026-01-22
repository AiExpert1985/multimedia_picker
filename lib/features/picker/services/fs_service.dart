import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class FsService {
  /// Copies a file to the target directory safely.
  /// If a file with the same name exists, it appends a number to the filename.
  /// Returns the copied File if successful, or throws if failed.
  Future<File> safeCopy(File source, Directory targetDir) async {
    if (!await source.exists()) {
      throw Exception("Source file does not exist: ${source.path}");
    }

    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    String filename = path.basename(source.path);
    String destPath = path.join(targetDir.path, filename);

    // Handle duplicates: filename.ext -> filename(1).ext
    int counter = 1;
    while (await File(destPath).exists()) {
      String nameWithoutExt = path.basenameWithoutExtension(filename);
      String ext = path.extension(filename);
      destPath = path.join(targetDir.path, '$nameWithoutExt($counter)$ext');
      counter++;
    }

    // Copy
    final copiedFile = await source.copy(destPath);

    // Verify
    if (!await copiedFile.exists()) {
      throw Exception("Copy verification failed for ${copiedFile.path}");
    }

    return copiedFile;
  }
}
