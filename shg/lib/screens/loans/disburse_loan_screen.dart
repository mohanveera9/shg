import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisburseLoanScreen extends ConsumerWidget {
  const DisburseLoanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('DisburseLoanScreen')),
      body: Center(
        child: Text('DisburseLoanScreen - Implementation in progress'),
      ),
    );
  }
}
