import 'package:flutter/material.dart';
import 'router.dart';
import 'theme/app_theme_data.dart';
import '../shared/theme_provider.dart';

/// Core App entry widget — listens to ThemeProvider for live dark/light switching.
class BrainVaultApp extends StatefulWidget {
  const BrainVaultApp({super.key});

  @override
  State<BrainVaultApp> createState() => _BrainVaultAppState();
}

class _BrainVaultAppState extends State<BrainVaultApp> {
  final _themeProvider = ThemeProvider.instance;

  @override
  void initState() {
    super.initState();
    _themeProvider.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    _themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrainVault',
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.light,
      darkTheme: AppThemeData.dark,
      themeMode: _themeProvider.themeMode,
      initialRoute: AppRouter.splashscreen,
      routes: AppRouter.routes,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
