// lib/providers/recent_documents_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/document.dart';

class RecentDocumentsProvider with ChangeNotifier {
  List<Document> _recentDocuments = [];
  final SharedPreferences prefs;
  static const String _storageKey = 'recent_documents';

  RecentDocumentsProvider(this.prefs) {
    _loadRecentDocuments();
  }

  List<Document> get recentDocuments => List.unmodifiable(_recentDocuments);

  Future<void> _loadRecentDocuments() async {
    try {
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _recentDocuments = jsonList
            .map((json) => Document.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading recent documents: $e');
    }
  }

  Future<void> _saveRecentDocuments() async {
    try {
      final String jsonString =
          json.encode(_recentDocuments.map((doc) => doc.toJson()).toList());
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving recent documents: $e');
    }
  }

  Future<void> addDocument(Document document) async {
    try {
      _recentDocuments.removeWhere((doc) => doc.path == document.path);
      _recentDocuments.insert(0, document);
      await _saveRecentDocuments();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding document: $e');
    }
  }

  Future<void> clearRecentDocuments() async {
    try {
      _recentDocuments.clear();
      await prefs.remove(_storageKey);
      notifyListeners();
    } catch (e) {
      debugPrint('Error clearing recent documents: $e');
      rethrow;
    }
  }
}
