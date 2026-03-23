// lib/models/document.dart
class Document {
  final String name;
  final String path;
  final String type;
  final DateTime lastOpened;

  Document({
    required this.name,
    required this.path,
    required this.type,
    required this.lastOpened,
  });

  // Convert Document to Map
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'type': type,
      'lastOpened': lastOpened.toIso8601String(),
    };
  }

  // Create Document from Map
  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      name: json['name'] as String,
      path: json['path'] as String,
      type: json['type'] as String,
      lastOpened: DateTime.parse(json['lastOpened'] as String),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Document &&
          runtimeType == other.runtimeType &&
          path == other.path;

  @override
  int get hashCode => path.hashCode;
}
