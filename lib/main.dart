import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'services/storage_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GranthaSudhaApp());
}

class GranthaSudhaApp extends StatefulWidget {
  const GranthaSudhaApp({super.key});

  @override
  State<GranthaSudhaApp> createState() => _GranthaSudhaAppState();
}

class _GranthaSudhaAppState extends State<GranthaSudhaApp> {
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final mode = await StorageService.getThemeMode();
    setState(() => _isDark = mode == 'dark');
  }

  void _toggleTheme() async {
    setState(() => _isDark = !_isDark);
    await StorageService.setThemeMode(_isDark ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(
        isDark: _isDark,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}
