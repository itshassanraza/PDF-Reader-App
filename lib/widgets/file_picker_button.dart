import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FilePickerButton extends StatelessWidget {
  final Function(File) onFileSelected;

  const FilePickerButton({
    super.key,
    required this.onFileSelected,
  });

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'pdf'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        onFileSelected(file);
      }
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: _pickFile,
      icon: const Icon(Icons.file_upload),
      label: const Text('Select Document'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }
}
