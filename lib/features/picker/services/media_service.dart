import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'fs_service.dart';

// Providers
final fsServiceProvider = Provider<FsService>((ref) => FsService());

final mediaServiceProvider = Provider<MediaService>((ref) {
  return MediaService(ref.watch(fsServiceProvider));
});

class MediaService {
  final FsService _fsService;

  MediaService(this._fsService);

  Future<PlatformFile?> pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
      allowMultiple: false,
    );
    return result?.files.single;
  }

  Future<File> processMedia(PlatformFile pickedFile) async {
    if (pickedFile.path == null) {
      throw Exception("Picked file path is null");
    }

    final sourceFile = File(pickedFile.path!);

    // Use app documents directory for safe storage
    final appDir = await getApplicationDocumentsDirectory();
    final mediaDir = Directory('${appDir.path}/Media');

    return _fsService.safeCopy(sourceFile, mediaDir);
  }

  Future<void> deleteOriginal(String originalPath) async {
    final original = File(originalPath);
    if (await original.exists()) {
      await original.delete();
    }
  }
}
