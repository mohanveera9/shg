import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import 'config/app_theme.dart';
import 'config/routes.dart';
import 'providers/riverpod_providers.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use settingsProvider language which loads from storage on app start
    final settings = ref.watch(settingsProvider);
    final language = settings.language;

    return MaterialApp(
      title: 'SHG Management',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      locale: Locale(language),
      supportedLocales: const [
        Locale('en'),
        Locale('te'),
      ],
      localizationsDelegates: [
        // Removed 'const' here
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.getRoutes(),
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
