import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/media_service.dart';

class PickerScreen extends ConsumerStatefulWidget {
  const PickerScreen({super.key});

  @override
  ConsumerState<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends ConsumerState<PickerScreen> {
  String _status = "Ready to pick";
  bool _isLoading = false;

  void _setStatus(String status) {
    if (mounted) {
      setState(() => _status = status);
    }
  }

  void _setLoading(bool loading) {
    if (mounted) {
      setState(() => _isLoading = loading);
    }
  }

  Future<void> _handlePick() async {
    _setLoading(true);
    _setStatus("Picking file...");

    try {
      final mediaService = ref.read(mediaServiceProvider);
      final pickedFile = await mediaService.pickMedia();

      if (pickedFile == null) {
        _setStatus("Pick cancelled");
        _setLoading(false);
        return;
      }

      _setStatus("Copying file...");
      final copiedFile = await mediaService.processMedia(pickedFile);

      _setStatus("Copied to: ${copiedFile.path}");

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Copy successful: ${copiedFile.path}")),
        );

        // Prompt for deletion
        // Pass identifier (Content URI) if available, otherwise path
        _showDeleteDialog(pickedFile.identifier ?? pickedFile.path!);
      }
    } catch (e) {
      _setStatus("Error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _showDeleteDialog(String originalUri) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Delete Original?"),
        content: const Text(
          "File has been safely copied. Do you want to delete the original file from device storage?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No, Keep Original"),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteOriginal(originalUri);
            },
            child: const Text("Yes, Delete"),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteOriginal(String originalUri) async {
    _setLoading(true);
    _setStatus("Deleting original...");
    try {
      await ref.read(mediaServiceProvider).deleteOriginal(originalUri);
      _setStatus("Original deleted.");
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Original file deleted")));
      }
    } catch (e) {
      _setStatus("Deletion Failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Deletion Failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Multimedia Picker")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _status,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                FilledButton.icon(
                  onPressed: _handlePick,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: const Text("Pick Image/Video"),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
