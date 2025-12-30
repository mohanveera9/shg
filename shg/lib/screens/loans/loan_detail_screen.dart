import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';

class LoanDetailScreen extends ConsumerStatefulWidget {
  final String loanId;

  const LoanDetailScreen({super.key, required this.loanId});

  @override
  ConsumerState<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends ConsumerState<LoanDetailScreen> {
  late Future<Map<String, dynamic>> _loanDetailFuture;

  @override
  void initState() {
    super.initState();
    _loanDetailFuture = _fetchLoanDetails();
  }

  Future<Map<String, dynamic>> _fetchLoanDetails() async {
    final apiService = ref.read(apiServiceProvider);
    return apiService.get('/loans/detail/${widget.loanId}', needsAuth: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Details'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loanDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.data!['success']) {
            return Center(
              child: Text('Error: ${snapshot.error ?? snapshot.data!['message']}'),
            );
          }

          final loan = snapshot.data!['loan'];
          final repayments = snapshot.data!['repayments'] ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Borrower', style: Theme.of(context).textTheme.bodySmall),
                                const SizedBox(height: 4),
                                Text(
                                  loan['borrowerName'] ?? 'Unknown',
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(loan['status']).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              loan['status'],
                              style: TextStyle(
                                color: _getStatusColor(loan['status']),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow('Purpose', loan['purpose'] ?? '-'),
                      _buildDetailRow('Requested Amount', '₹${loan['requestedAmount'].toStringAsFixed(0)}'),
                      if (loan['approvedAmount'] != null)
                        _buildDetailRow('Approved Amount', '₹${loan['approvedAmount'].toStringAsFixed(0)}'),
                      if (loan['interestRate'] != null)
                        _buildDetailRow('Interest Rate', '${loan['interestRate']}%'),
                      if (loan['tenureMonths'] != null)
                        _buildDetailRow('Tenure', '${loan['tenureMonths']} months'),
                      if (loan['emiAmount'] != null)
                        _buildDetailRow('EMI Amount', '₹${loan['emiAmount'].toStringAsFixed(0)}'),
                      _buildDetailRow('Total Paid', '₹${loan['totalPaid'].toStringAsFixed(0)}'),
                      if (loan['remainingBalance'] != null)
                        _buildDetailRow('Remaining Balance', '₹${loan['remainingBalance'].toStringAsFixed(0)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (loan['status'] == 'APPROVED' || loan['status'] == 'DISBURSED')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loan['status'] == 'APPROVED'
                        ? () => Navigator.of(context).pushNamed(AppRoutes.disburseLoan, arguments: widget.loanId)
                        : () => Navigator.of(context).pushNamed(AppRoutes.repayEmi, arguments: widget.loanId),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(loan['status'] == 'APPROVED' ? 'Disburse Loan' : 'Make Payment'),
                  ),
                ),
              const SizedBox(height: 16),
              Text('Repayment History', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              if (repayments.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'No repayments yet',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                    ),
                  ),
                )
              else
                ...repayments.map<Widget>((repayment) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text('₹${repayment['amount'].toStringAsFixed(0)}'),
                    subtitle: Text(repayment['paymentDate'] ?? ''),
                    trailing: Text(
                      repayment['paymentMethod'] ?? 'N/A',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )).toList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
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
