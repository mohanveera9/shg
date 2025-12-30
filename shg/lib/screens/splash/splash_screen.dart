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
      // Check if user needs to complete profile
      if (authState.user?.name == null || authState.user!.name.isEmpty) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.completeProfile);
        return;
      }
      
      final groupNotifier = ref.read(groupProvider.notifier);
      await groupNotifier.fetchUserGroups();
      
      if (!mounted) return;
      
      // Always navigate to solo dashboard first
      Navigator.of(context).pushReplacementNamed(AppRoutes.soloDashboard);
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
