import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoansDashboardScreen extends ConsumerWidget {
  const LoansDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoansDashboardScreen')),
      body: Center(
        child: Text('LoansDashboardScreen - Implementation in progress'),
      ),
    );
  }
}
