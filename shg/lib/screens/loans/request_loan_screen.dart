import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RequestLoanScreen extends ConsumerWidget {
  const RequestLoanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('RequestLoanScreen')),
      body: Center(
        child: Text('RequestLoanScreen - Implementation in progress'),
      ),
    );
  }
}
