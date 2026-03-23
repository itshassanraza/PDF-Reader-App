import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/recent_documents_provider.dart';
import 'document_viewer_screen.dart';

class RecentFilesScreen extends StatelessWidget {
  const RecentFilesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecentDocumentsProvider>(
      builder: (context, provider, child) {
        final recentDocs = provider.recentDocuments;

        if (recentDocs.isEmpty) {
          return const Center(
            child: Text('No recent documents'),
          );
        }

        return ListView.builder(
          itemCount: recentDocs.length,
          itemBuilder: (context, index) {
            final doc = recentDocs[index];
            return ListTile(
              leading: _getFileIcon(doc.type),
              title: Text(doc.name),
              subtitle: Text('Last opened: ${_formatDate(doc.lastOpened)}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DocumentViewerScreen(document: doc),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }

  Icon _getFileIcon(String type) {
    switch (type.toLowerCase()) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red);
      case 'doc':
      case 'docx':
        return const Icon(Icons.description, color: Colors.blue);
      case 'xls':
      case 'xlsx':
        return const Icon(Icons.table_chart, color: Colors.green);
      case 'ppt':
      case 'pptx':
        return const Icon(Icons.present_to_all_outlined, color: Colors.orange);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }
}
