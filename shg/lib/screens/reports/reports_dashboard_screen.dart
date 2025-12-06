import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportsDashboardScreen extends ConsumerWidget {
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReportsDashboardScreen')),
      body: Center(
        child: Text('ReportsDashboardScreen - Implementation in progress'),
      ),
    );
  }
}
