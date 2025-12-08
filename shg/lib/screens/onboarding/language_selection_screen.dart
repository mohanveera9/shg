import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/app_config.dart';
import '../../config/routes.dart';
import '../../providers/riverpod_providers.dart';
import '../../services/storage_service.dart';

class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  String _selectedLanguage = AppConfig.defaultLanguage;
  
  @override
  void initState() {
    super.initState();
    // Load saved language preference
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final storage = StorageService();
      final savedLanguage = await storage.getLanguage();
      if (mounted) {
        setState(() {
          _selectedLanguage = savedLanguage;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.language,
                size: 80,
                color: Colors.teal,
              ),
              const SizedBox(height: 32),
              const Text(
                'Select Language / భాష ఎంచుకోండి',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              ...AppConfig.supportedLanguages.map((lang) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RadioListTile<String>(
                    title: Text(
                      AppConfig.languageNames[lang] ?? lang,
                      style: const TextStyle(fontSize: 20),
                    ),
                    value: lang,
                    groupValue: _selectedLanguage,
                    onChanged: (value) {
                      setState(() {
                        _selectedLanguage = value!;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedLanguage == lang
                            ? Theme.of(context).primaryColor
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final storage = StorageService();
                    await storage.saveLanguage(_selectedLanguage);
                    // Update both providers
                    ref.read(settingsProvider.notifier).setLanguage(_selectedLanguage);
                    ref.read(languageProvider.notifier).setLanguage(_selectedLanguage);
                    if (mounted) {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.permissions);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Continue / కొనసాగించు',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
