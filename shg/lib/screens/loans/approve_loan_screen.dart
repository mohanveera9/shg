import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApproveLoanScreen extends ConsumerWidget {
  const ApproveLoanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ApproveLoanScreen')),
      body: Center(
        child: Text('ApproveLoanScreen - Implementation in progress'),
      ),
    );
  }
}
