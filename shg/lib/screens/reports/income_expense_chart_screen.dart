import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';

class IncomeExpenseChartScreen extends ConsumerWidget {
  const IncomeExpenseChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider).currentGroup;
    final transactionsAsync = group != null ? ref.watch(transactionsProvider(group.id)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Income & Expenses'),
        elevation: 0,
      ),
      body: transactionsAsync == null
          ? const Center(child: Text('No group selected'))
          : transactionsAsync.when(
              data: (transactions) {
                double totalIncome = 0;
                double totalExpense = 0;

                for (final tx in transactions) {
                  if (tx.type == 'INCOME') {
                    totalIncome += tx.amount;
                  } else if (tx.type == 'EXPENSE') {
                    totalExpense += tx.amount;
                  }
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    const Icon(Icons.trending_up, color: Colors.green, size: 32),
                                    const SizedBox(height: 8),
                                    Text('Income', style: Theme.of(context).textTheme.bodySmall),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${totalIncome.toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.green),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.trending_down, color: Colors.red, size: 32),
                                    const SizedBox(height: 8),
                                    Text('Expense', style: Theme.of(context).textTheme.bodySmall),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${totalExpense.toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const Icon(Icons.balance, color: Colors.blue, size: 32),
                                    const SizedBox(height: 8),
                                    Text('Balance', style: Theme.of(context).textTheme.bodySmall),
                                    const SizedBox(height: 4),
                                    Text(
                                      '₹${(totalIncome - totalExpense).toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.blue),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...transactions.take(10).map((tx) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          tx.type == 'INCOME' ? Icons.add : Icons.remove,
                          color: tx.type == 'INCOME' ? Colors.green : Colors.red,
                        ),
                        title: Text(tx.category),
                        subtitle: Text(tx.notes ?? '-'),
                        trailing: Text(
                          '₹${tx.amount.toStringAsFixed(0)}',
                          style: TextStyle(
                            color: tx.type == 'INCOME' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
    );
  }
}
