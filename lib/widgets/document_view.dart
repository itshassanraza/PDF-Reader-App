import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';

class DocumentView extends StatelessWidget {
  final File file;

  const DocumentView({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    final String extension = file.path.split('.').last.toLowerCase();

    switch (extension) {
      case 'pdf':
        return SfPdfViewer.file(file);
      case 'doc':
      case 'docx':
      case 'xls':
      case 'xlsx':
      case 'ppt':
      case 'pptx':
        return Center(
          child: Text(
              '${extension.toUpperCase()} files are opened in external viewer'),
        );
      default:
        return const Center(
          child: Text('Unsupported file format'),
        );
    }
  }
}
