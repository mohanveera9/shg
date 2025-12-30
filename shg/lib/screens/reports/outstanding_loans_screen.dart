import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/theme.dart';

class OutstandingLoansScreen extends ConsumerWidget {
  const OutstandingLoansScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider).currentGroup;
    final loansAsync = group != null ? ref.watch(loansProvider(group.id)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Outstanding Loans'),
        elevation: 0,
      ),
      body: loansAsync == null
          ? const Center(child: Text('No group selected'))
          : loansAsync.when(
              data: (loans) {
                final outstanding = loans.where((l) => l.status == 'DISBURSED').toList();

                if (outstanding.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text('No Outstanding Loans', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text('Total Outstanding', style: Theme.of(context).textTheme.bodySmall),
                            const SizedBox(height: 8),
                            Text(
                              '₹${outstanding.fold<double>(0, (sum, l) => sum + (l.remainingBalance ?? 0)).toStringAsFixed(0)}',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ...outstanding.map((loan) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(loan.borrowerName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Purpose: ${loan.purpose}'),
                            Text('Remaining: ₹${loan.remainingBalance?.toStringAsFixed(0) ?? '0'}'),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: AppTheme.primaryGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
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
