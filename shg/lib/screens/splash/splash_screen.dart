import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final authNotifier = ref.read(authProvider.notifier);
    await authNotifier.checkAuthStatus();
    
    final authState = ref.read(authProvider);

    if (!mounted) return;

    if (authState.isAuthenticated) {
      final groupNotifier = ref.read(groupProvider.notifier);
      await groupNotifier.fetchUserGroups();
      
      final groupState = ref.read(groupProvider);
      
      if (!mounted) return;
      
      if (groupState.groups.isEmpty) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.groupSelection);
      } else {
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.languageSelection);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups,
              size: 100,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            const Text(
              'SHG Management',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
