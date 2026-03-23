// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'providers/settings_provider.dart';
import 'providers/recent_documents_provider.dart';
import 'screens/home_screen.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;

  const MyApp({
    Key? key,
    required this.prefs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => RecentDocumentsProvider(prefs),
        ),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Document Viewer',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: settings.themeMode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
