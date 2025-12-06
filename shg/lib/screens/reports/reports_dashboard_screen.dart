import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';

class ReportsDashboardScreen extends ConsumerWidget {
  const ReportsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Analytics & Reports',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          _buildReportCard(
            context,
            'Income & Expense',
            'View income and expense trends',
            Icons.trending_up,
            AppTheme.lightGreen,
            () => Navigator.of(context).pushNamed('/income-expense-chart'),
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'Savings by Member',
            'Track member savings',
            Icons.savings,
            AppTheme.lightBlue,
            () => Navigator.of(context).pushNamed('/savings-by-member'),
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'Outstanding Loans',
            'View pending loans',
            Icons.receipt_long,
            AppTheme.lightOrange,
            () => Navigator.of(context).pushNamed('/outstanding-loans'),
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'Top Products',
            'Best selling products',
            Icons.star,
            AppTheme.lightPurple,
            () => Navigator.of(context).pushNamed('/top-products'),
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
