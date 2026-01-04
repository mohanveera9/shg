import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/routes.dart';
import '../../models/transaction.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({super.key});

  @override
  ConsumerState<TransactionsListScreen> createState() => _TransactionsListScreenState();
}

class _TransactionsListScreenState extends ConsumerState<TransactionsListScreen> {
  String? _selectedFilter;

  List<Transaction> _filterTransactions(List<Transaction> transactions) {
    if (_selectedFilter == null) {
      return transactions;
    }
    return transactions.where((t) => t.type == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () async {
          if (groupState.currentGroup != null) {
            ref.invalidate(transactionsProvider(groupState.currentGroup!.id));
          }
        },
        child: transactionsAsync.when(
          data: (transactions) {
            final filteredTransactions = _filterTransactions(transactions);
            
            return Column(
              children: [
                // Filter Chips
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          label: const Text('All'),
                          showCheckmark: false,
                          selected: _selectedFilter == null,
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          label: Text(l10n.income),
                          showCheckmark: false,
                          selected: _selectedFilter == 'INCOME',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? 'INCOME' : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          label: Text(l10n.expense),
                          showCheckmark: false,
                          selected: _selectedFilter == 'EXPENSE',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? 'EXPENSE' : null;
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          label: Text(l10n.savings),
                          showCheckmark: false,
                          selected: _selectedFilter == 'SAVINGS',
                          onSelected: (selected) {
                            setState(() {
                              _selectedFilter = selected ? 'SAVINGS' : null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                // Transactions List or Empty State
                Expanded(
                  child: filteredTransactions.isEmpty
                      ? Center(
                          child: Text(
                            l10n.empty_state,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredTransactions.length,
                          itemBuilder: (context, index) {
                            final transaction = filteredTransactions[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: _getTypeColor(transaction.type),
                                  child: Text(
                                    transaction.type[0],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  transaction.category,
                                  style: const TextStyle(fontWeight: FontWeight.w500),
                                ),
                                subtitle: Text(
                                  transaction.date.toString().split(' ')[0],
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                trailing: Text(
                                  '₹${transaction.amount.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: _getTypeColor(transaction.type),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  'Error: $error',
                  style: TextStyle(color: Colors.red[700]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'INCOME':
        return Colors.green;
      case 'EXPENSE':
        return Colors.red;
      case 'SAVINGS':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
