import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddEditProductScreen extends ConsumerWidget {
  final bool isEdit;
  const AddEditProductScreen({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add Product')),
      body: Center(
        child: Text('AddEditProductScreen - Implementation in progress'),
      ),
    );
  }
}
