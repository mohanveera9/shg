import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TopProductsScreen extends ConsumerWidget {
  const TopProductsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('TopProductsScreen')),
      body: Center(
        child: Text('TopProductsScreen - Implementation in progress'),
      ),
    );
  }
}
