import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../providers/recent_documents_provider.dart' as provider;
import '../models/document.dart';
import 'document_viewer_screen.dart';
import 'recent_files_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Future<void> _pickFile() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: [
            'pdf',
            'doc',
            'docx',
            'xls',
            'xlsx',
            'ppt',
            'pptx'
          ],
        );

        if (result != null) {
          final file = result.files.single;
          final document = Document(
            name: file.name,
            path: file.path!,
            type: file.extension ?? '',
            lastOpened: DateTime.now(),
          );

          // Add to recent documents
          Provider.of<provider.RecentDocumentsProvider>(context, listen: false)
              .addDocument(document);

          // Navigate to viewer
          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DocumentViewerScreen(document: document),
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error picking file: $e')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Office Reader'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _pickFile,
                    icon: const Icon(Icons.file_open),
                    label: const Text('Open Document'),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Recent Files',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Consumer<provider.RecentDocumentsProvider>(
                      builder: (context, providerInstance, child) {
                        final recentDocs = providerInstance.recentDocuments;
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
                              subtitle: Text(doc.type.toUpperCase()),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DocumentViewerScreen(document: doc),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          : const RecentFilesScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Recent',
          ),
        ],
      ),
    );
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
        return const Icon(Icons.slideshow, color: Colors.orange);
      default:
        return const Icon(Icons.insert_drive_file);
    }
  }
}
