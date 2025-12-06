#!/bin/bash

# Script to create all placeholder screens for SHG Management App

cd /home/engine/project/shg/lib/screens

# Create placeholder screen files with basic implementations

# Bookkeeping Module
cat > bookkeeping/transactions_list_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';

class TransactionsListScreen extends ConsumerWidget {
  const TransactionsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final groupState = ref.watch(groupProvider);

    if (groupState.currentGroup == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.transactions)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final transactionsAsync = ref.watch(transactionsProvider(groupState.currentGroup!.id));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.transactions)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addTransaction),
        child: const Icon(Icons.add),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(child: Text(l10n.empty_state));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(transaction.type[0]),
                  ),
                  title: Text(transaction.category),
                  subtitle: Text(transaction.date.toString().split(' ')[0]),
                  trailing: Text(
                    '₹${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
EOF

cat > bookkeeping/add_transaction_screen.dart <<'EOF'
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
EOF

# Create all loan screens
for screen in loans_dashboard request_loan my_loans loan_detail repay_emi pending_approvals approve_loan disburse_loan; do
  class_name="$(echo $screen | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' | sed 's/ //g')Screen"
  cat > loans/${screen}_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${class_name} extends ConsumerWidget {
  const ${class_name}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('${class_name}')),
      body: Center(
        child: Text('${class_name} - Implementation in progress'),
      ),
    );
  }
}
EOF
done

# Create all product screens
for screen in products_list add_edit_product product_detail; do
  class_name="$(echo $screen | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' | sed 's/ //g')Screen"
  if [ "$screen" == "add_edit_product" ]; then
    cat > products/${screen}_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${class_name} extends ConsumerWidget {
  final bool isEdit;
  const ${class_name}({super.key, this.isEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Product' : 'Add Product')),
      body: Center(
        child: Text('${class_name} - Implementation in progress'),
      ),
    );
  }
}
EOF
  else
    cat > products/${screen}_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${class_name} extends ConsumerWidget {
  const ${class_name}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('${class_name}')),
      body: Center(
        child: Text('${class_name} - Implementation in progress'),
      ),
    );
  }
}
EOF
  fi
done

# Create all order screens
for screen in orders_list order_detail; do
  class_name="$(echo $screen | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' | sed 's/ //g')Screen"
  cat > orders/${screen}_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${class_name} extends ConsumerWidget {
  const ${class_name}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('${class_name}')),
      body: Center(
        child: Text('${class_name} - Implementation in progress'),
      ),
    );
  }
}
EOF
done

# Create all report screens
for screen in reports_dashboard income_expense_chart savings_by_member outstanding_loans top_products; do
  class_name="$(echo $screen | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' | sed 's/ //g')Screen"
  cat > reports/${screen}_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${class_name} extends ConsumerWidget {
  const ${class_name}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('${class_name}')),
      body: Center(
        child: Text('${class_name} - Implementation in progress'),
      ),
    );
  }
}
EOF
done

# Create profile and settings screens
for screen in profile edit_profile; do
  class_name="$(echo $screen | sed 's/_/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1' | sed 's/ //g')Screen"
  cat > profile/${screen}_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ${class_name} extends ConsumerWidget {
  const ${class_name}({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('${class_name}')),
      body: Center(
        child: Text('${class_name} - Implementation in progress'),
      ),
    );
  }
}
EOF
done

cat > settings/settings_screen.dart <<EOF
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.notifications),
            value: settings.notificationsEnabled,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setNotifications(value);
            },
          ),
          SwitchListTile(
            title: Text(l10n.data_usage),
            value: settings.dataUsageAllowed,
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setDataUsage(value);
            },
          ),
          ListTile(
            title: Text(l10n.language_selection_label),
            trailing: DropdownButton<String>(
              value: settings.language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'te', child: Text('తెలుగు')),
              ],
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).setLanguage(value);
                  ref.read(languageProvider.notifier).state = value;
                }
              },
            ),
          ),
          ListTile(
            title: Text(l10n.app_version),
            trailing: const Text('1.0.0'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(l10n.logout, style: const TextStyle(color: Colors.red)),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.languageSelection,
                  (route) => false,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
EOF

echo "All placeholder screens created successfully!"
EOF

chmod +x /home/engine/project/CREATE_ALL_SCREENS.sh
