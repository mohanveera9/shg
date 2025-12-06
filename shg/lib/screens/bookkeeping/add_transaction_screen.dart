import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String _type = 'INCOME';
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    _categoryController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final groupState = ref.read(groupProvider);
    final api = ref.read(apiServiceProvider);

    final data = {
      'type': _type,
      'amount': double.parse(_amountController.text),
      'category': _categoryController.text,
      'notes': _notesController.text,
      'date': _selectedDate.toIso8601String(),
    };

    final response = await api.post(
      '/transactions/${groupState.currentGroup!.id}',
      data,
      needsAuth: true,
    );

    setState(() => _isLoading = false);

    if (mounted) {
      if (response['success'] == true) {
        ref.invalidate(transactionsProvider(groupState.currentGroup!.id));
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Transaction added successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to add transaction')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.add_transaction)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _type,
                      decoration: InputDecoration(labelText: l10n.type),
                      items: [
                        DropdownMenuItem(value: 'INCOME', child: Text(l10n.income)),
                        DropdownMenuItem(value: 'EXPENSE', child: Text(l10n.expense)),
                        DropdownMenuItem(value: 'SAVINGS', child: Text(l10n.savings)),
                      ],
                      onChanged: (value) => setState(() => _type = value!),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: l10n.amount),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Required';
                        if (double.tryParse(value) == null) return 'Invalid amount';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _categoryController,
                      decoration: InputDecoration(labelText: l10n.category),
                      validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notesController,
                      decoration: InputDecoration(labelText: l10n.notes),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _submitTransaction,
                      child: Text(l10n.submit),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
