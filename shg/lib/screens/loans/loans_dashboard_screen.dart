import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/theme.dart';

class LoansDashboardScreen extends ConsumerWidget {
  const LoansDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(groupProvider).currentGroup;
    final loansAsync = group != null ? ref.watch(loansProvider(group.id)) : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
        elevation: 0,
      ),
      body: loansAsync == null
          ? const Center(child: Text('No group selected'))
          : loansAsync.when(
              data: (loans) {
                if (loans.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'No Loans Yet',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create or view loans here',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }

                final approvedLoans = loans.where((l) => l.status == 'APPROVED').length;
                final disbursedLoans = loans.where((l) => l.status == 'DISBURSED').length;
                final requestedLoans = loans.where((l) => l.status == 'REQUESTED').length;
                final totalAmount = loans.fold<double>(0, (sum, l) => sum + (l.approvedAmount ?? l.requestedAmount));

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildStatCard(
                      context,
                      'Total Loans',
                      loans.length.toString(),
                      Icons.trending_up,
                      AppTheme.primaryGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      context,
                      'Total Amount',
                      '₹${totalAmount.toStringAsFixed(0)}',
                      Icons.attach_money,
                      AppTheme.lightGreen,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      context,
                      'Pending Requests',
                      requestedLoans.toString(),
                      Icons.schedule,
                      AppTheme.lightOrange,
                    ),
                    const SizedBox(height: 12),
                    _buildStatCard(
                      context,
                      'Active Disbursals',
                      disbursedLoans.toString(),
                      Icons.verified,
                      AppTheme.lightBlue,
                    ),
                    const SizedBox(height: 24),
                    Text('Recent Loans', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    ...loans.take(5).map((loan) => _buildLoanCard(context, loan)).toList(),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/request-loan');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard(BuildContext context, dynamic loan) {
    final statusColor = _getStatusColor(loan.status);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(loan.borrowerName),
        subtitle: Text('₹${loan.approvedAmount?.toStringAsFixed(0) ?? loan.requestedAmount.toStringAsFixed(0)}'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            loan.status,
            style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        onTap: () => Navigator.of(context).pushNamed('/loan-detail', arguments: loan.id),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return AppTheme.primaryGreen;
      case 'DISBURSED':
        return AppTheme.primaryGreen;
      case 'REQUESTED':
        return Colors.orange;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
