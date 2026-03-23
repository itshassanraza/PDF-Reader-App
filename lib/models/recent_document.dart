class AppConstants {
  // App-wide constants
  static const String appName = 'Office Reader';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String keyDarkMode = 'dark_mode';
  static const String keyAutoOpen = 'auto_open';
  static const String keyRecentDocuments = 'recent_documents';
  static const String keyLastOpenedFiles = 'last_opened_files';

  // File Types
  static const List<String> supportedFileTypes = [
    'pdf',
    'doc',
    'docx',
    'xls',
    'xlsx',
    'ppt',
    'pptx'
  ];

  // Error Messages
  static const String errorStoragePermission = 'Storage permission denied';
  static const String errorFileNotFound = 'File not found';
  static const String errorUnsupportedFile = 'Unsupported file type';
  static const String errorLoadingFile = 'Error loading file';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double cardElevation = 4.0;
  static const int maxRecentFiles = 10;

  // File Type Icons
  static const Map<String, Map<String, dynamic>> fileTypeIcons = {
    'pdf': {'icon': 'picture_as_pdf', 'color': 0xFFE53935},
    'doc': {'icon': 'description', 'color': 0xFF1976D2},
    'docx': {'icon': 'description', 'color': 0xFF1976D2},
    'xls': {'icon': 'table_chart', 'color': 0xFF43A047},
    'xlsx': {'icon': 'table_chart', 'color': 0xFF43A047},
    'ppt': {'icon': 'presentation', 'color': 0xFFF4511E},
    'pptx': {'icon': 'presentation', 'color': 0xFFF4511E},
  };

  // Theme Colors
  static const Map<String, int> themeColors = {
    'primary': 0xFF2196F3,
    'secondary': 0xFF64B5F6,
    'accent': 0xFF1976D2,
    'error': 0xFFE53935,
    'success': 0xFF43A047,
    'warning': 0xFFFFA000,
  };
}

class DateTimeFormats {
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String shortDateFormat = 'dd/MM/yy';
  static const String shortTimeFormat = 'HH:mm';
}

class StoragePaths {
  static const String cacheDir = 'cache';
  static const String tempDir = 'temp';
  static const String documentsDir = 'documents';
}
