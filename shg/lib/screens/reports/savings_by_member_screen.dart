import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SavingsByMemberScreen extends ConsumerWidget {
  const SavingsByMemberScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('SavingsByMemberScreen')),
      body: Center(
        child: Text('SavingsByMemberScreen - Implementation in progress'),
      ),
    );
  }
}
