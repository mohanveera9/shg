import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/group_provider.dart';
import '../../config/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.checkAuthStatus();

    if (!mounted) return;

    if (authProvider.isAuthenticated) {
      final groupProvider = Provider.of<GroupProvider>(context, listen: false);
      await groupProvider.fetchUserGroups();
      
      if (!mounted) return;
      
      if (groupProvider.groups.isEmpty) {
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
