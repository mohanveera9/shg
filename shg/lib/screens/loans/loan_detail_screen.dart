import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoanDetailScreen extends ConsumerWidget {
  const LoanDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('LoanDetailScreen')),
      body: Center(
        child: Text('LoanDetailScreen - Implementation in progress'),
      ),
    );
  }
}
