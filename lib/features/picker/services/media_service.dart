import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/file_service.dart';

// Providers
final fileServiceProvider = Provider<FileService>((ref) => FileService());

final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService(ref.watch(fileServiceProvider));
});

class MediaService {
  final FileService _fileService;

  MediaService(this._fileService);

  Future<PlatformFile?> pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
      withData: false,
      withReadStream: false,
    );
    return result?.files.single;
  }

  Future<File> processMedia(PlatformFile pickedFile) async {
    if (pickedFile.path == null) {
      throw Exception("Picked file path is null");
    }

    // copyFileToStorage now handles storage checks and path generation
    final destinationPath = await _fileService.copyFileToStorage(
      pickedFile.path!,
    );

    // verifyFileCopy is not strictly needed here as copyFileToStorage throws on error,
    // but we can sanity check if we want, or just return the file.
    return File(destinationPath);
  }

  Future<void> deleteOriginal(String originalPathOrUri) async {
    final success = await _fileService.deleteOriginalFile(originalPathOrUri);
    if (!success) {
      throw Exception("Failed to delete original file");
    }
  }
}
