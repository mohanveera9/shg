import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingApprovalsScreen extends ConsumerWidget {
  const PendingApprovalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('PendingApprovalsScreen')),
      body: Center(
        child: Text('PendingApprovalsScreen - Implementation in progress'),
      ),
    );
  }
}
