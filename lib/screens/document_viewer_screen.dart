import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:excel/excel.dart';
import 'package:archive/archive.dart';
import 'dart:convert';
import 'dart:io';
import '../models/document.dart';

class DocumentViewerScreen extends StatefulWidget {
  final Document document;

  const DocumentViewerScreen({
    Key? key,
    required this.document,
  }) : super(key: key);

  @override
  _DocumentViewerScreenState createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  bool _isLoading = true;
  dynamic _documentData;
  String _error = '';
  String _docContent = '';

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final file = File(widget.document.path);
      if (!await file.exists()) {
        throw Exception('File not found');
      }

      final bytes = await file.readAsBytes();

      switch (widget.document.type.toLowerCase()) {
        case 'xlsx':
        case 'xls':
          _documentData = Excel.decodeBytes(bytes);
          break;
        case 'docx':
          await _extractDocxContent(bytes);
          break;
        case 'doc':
          _error = '.doc files are not supported. Please convert to .docx';
          break;
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error loading document: $e';
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading document: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _extractDocxContent(List<int> bytes) async {
    try {
      // Decode the DOCX file (which is a ZIP archive)
      final archive = ZipDecoder().decodeBytes(bytes);

      // Find the document.xml file which contains the main content
      final documentFile = archive.findFile('word/document.xml');

      if (documentFile != null) {
        // Extract and decode the content
        final content = utf8.decode(documentFile.content);

        // Basic XML parsing to extract text
        _docContent = content
            .replaceAll(RegExp(r'<[^>]*>'), '\n') // Remove XML tags
            .replaceAll('&amp;', '&') // Replace XML entities
            .replaceAll('&lt;', '<')
            .replaceAll('&gt;', '>')
            .replaceAll('&quot;', '"')
            .replaceAll('&apos;', "'")
            .replaceAll(RegExp(r'\n{2,}'), '\n\n') // Remove extra newlines
            .trim();
      } else {
        throw Exception('Could not find document content');
      }
    } catch (e) {
      throw Exception('Error extracting DOCX content: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.document.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadDocument,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildViewer(),
    );
  }

  Widget _buildViewer() {
    if (_error.isNotEmpty) {
      return Center(
        child: Text(
          _error,
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }

    try {
      switch (widget.document.type.toLowerCase()) {
        case 'pdf':
          return SfPdfViewer.file(
            File(widget.document.path),
            onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error loading PDF: ${details.error}'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          );
        case 'xlsx':
        case 'xls':
          return _buildExcelViewer();
        case 'docx':
          return _buildDocxViewer();
        default:
          return Center(
            child: Text(
              'Unsupported file type: ${widget.document.type}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
      }
    } catch (e) {
      return Center(
        child: Text(
          'Error loading document: $e',
          style: const TextStyle(fontSize: 16, color: Colors.red),
        ),
      );
    }
  }

  Widget _buildDocxViewer() {
    if (_docContent.isEmpty) {
      return const Center(child: Text('No content found in document'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        _docContent,
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildExcelViewer() {
    // Excel viewer implementation remains the same
    if (_documentData == null || !(_documentData is Excel)) {
      return const Center(child: Text('No data found in Excel file'));
    }

    final excel = _documentData as Excel;
    if (excel.tables.isEmpty) {
      return const Center(child: Text('No sheets found in Excel file'));
    }

    return DefaultTabController(
      length: excel.tables.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: excel.tables.keys.map((sheet) {
              return Tab(text: sheet.toString());
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: excel.tables.entries.map((entry) {
                return _buildSheetView(entry.value);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetView(Sheet sheet) {
    final rows = sheet.rows;
    if (rows.isEmpty) {
      return const Center(child: Text('No data in sheet'));
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Table(
          border: TableBorder.all(),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: rows.map((row) {
            return TableRow(
              children: row.map((cell) {
                return Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    cell?.value?.toString() ?? '',
                    style: TextStyle(
                      fontWeight: rows.indexOf(row) == 0
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
