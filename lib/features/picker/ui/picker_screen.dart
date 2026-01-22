import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/picker_provider.dart';
import 'widgets/delete_confirmation_dialog.dart';

/// Minimal picker screen with button and status text
class PickerScreen extends ConsumerWidget {
  const PickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pickerState = ref.watch(pickerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Media Picker'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status text
              Text(
                pickerState.statusMessage,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),

              // Pick file button
              ElevatedButton(
                onPressed: pickerState.isLoading
                    ? null
                    : () => _handlePickFile(context, ref),
                child: pickerState.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Pick Media File'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePickFile(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(pickerProvider.notifier);

    // Step 1: Pick the file
    await notifier.pickMedia();

    final state = ref.read(pickerProvider);
    if (state.pickedFilePath == null) {
      return; // User cancelled or error occurred
    }

    // Step 2: Copy to storage
    final copySuccess = await notifier.copyToStorage();
    if (!copySuccess) {
      return; // Copy failed
    }

    // Step 3: Show confirmation dialog for deletion
    if (!context.mounted) return;

    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteConfirmationDialog(),
    );

    if (shouldDelete == true) {
      // Step 4: Delete original file
      final deleteSuccess = await notifier.deleteOriginal();

      if (!deleteSuccess && context.mounted) {
        // Show snackbar on deletion failure (per contract)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete original file'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else {
      // User declined deletion
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Original file kept')));
      }
    }
  }
}
