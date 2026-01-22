import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/services/file_service.dart';

/// State for the picker feature
class PickerState {
  final bool isLoading;
  final String statusMessage;
  final String? pickedFilePath;
  final String? copiedFilePath;

  const PickerState({
    this.isLoading = false,
    this.statusMessage = 'Tap button to pick a file',
    this.pickedFilePath,
    this.copiedFilePath,
  });

  PickerState copyWith({
    bool? isLoading,
    String? statusMessage,
    String? pickedFilePath,
    String? copiedFilePath,
  }) {
    return PickerState(
      isLoading: isLoading ?? this.isLoading,
      statusMessage: statusMessage ?? this.statusMessage,
      pickedFilePath: pickedFilePath ?? this.pickedFilePath,
      copiedFilePath: copiedFilePath ?? this.copiedFilePath,
    );
  }
}

/// Riverpod 3.x Notifier for picker state management
class PickerNotifier extends Notifier<PickerState> {
  late final FileService _fileService;

  @override
  PickerState build() {
    _fileService = FileService();
    return const PickerState();
  }

  /// Opens file picker to select image or video
  Future<void> pickMedia() async {
    state = state.copyWith(isLoading: true, statusMessage: 'Picking file...');

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.path != null) {
          state = state.copyWith(
            pickedFilePath: file.path,
            statusMessage: 'File picked: ${file.name}',
            isLoading: false,
          );
        } else {
          state = state.copyWith(
            statusMessage: 'Error: Could not get file path',
            isLoading: false,
          );
        }
      } else {
        state = state.copyWith(
          statusMessage: 'File picking cancelled',
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        statusMessage: 'Error picking file: $e',
        isLoading: false,
      );
    }
  }

  /// Copies the picked file to app storage
  Future<bool> copyToStorage() async {
    if (state.pickedFilePath == null) {
      state = state.copyWith(statusMessage: 'No file to copy');
      return false;
    }

    state = state.copyWith(isLoading: true, statusMessage: 'Copying file...');

    try {
      final destinationPath = await _fileService.copyFileToStorage(
        state.pickedFilePath!,
      );

      // Verify the copy was successful
      final verified = await _fileService.verifyFileCopy(destinationPath);

      if (verified) {
        state = state.copyWith(
          copiedFilePath: destinationPath,
          statusMessage: 'File copied successfully!',
          isLoading: false,
        );
        return true;
      } else {
        state = state.copyWith(
          statusMessage: 'Error: Copy verification failed',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        statusMessage: 'Error copying file: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Deletes the original file after user confirmation
  Future<bool> deleteOriginal() async {
    if (state.pickedFilePath == null) {
      state = state.copyWith(statusMessage: 'No original file to delete');
      return false;
    }

    state = state.copyWith(
      isLoading: true,
      statusMessage: 'Deleting original...',
    );

    try {
      final success = await _fileService.deleteOriginalFile(
        state.pickedFilePath!,
      );

      if (success) {
        state = state.copyWith(
          statusMessage: 'Original file deleted successfully!',
          isLoading: false,
          pickedFilePath: null,
        );
        return true;
      } else {
        state = state.copyWith(
          statusMessage: 'Failed to delete original file',
          isLoading: false,
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        statusMessage: 'Error deleting original: $e',
        isLoading: false,
      );
      return false;
    }
  }

  /// Resets the picker state
  void reset() {
    state = const PickerState();
  }
}

/// Provider for the picker notifier using Riverpod 3.x syntax
final pickerProvider = NotifierProvider<PickerNotifier, PickerState>(
  PickerNotifier.new,
);
