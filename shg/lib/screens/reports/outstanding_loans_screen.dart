import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OutstandingLoansScreen extends ConsumerWidget {
  const OutstandingLoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('OutstandingLoansScreen')),
      body: Center(
        child: Text('OutstandingLoansScreen - Implementation in progress'),
      ),
    );
  }
}
