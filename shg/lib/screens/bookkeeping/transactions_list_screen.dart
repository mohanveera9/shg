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
