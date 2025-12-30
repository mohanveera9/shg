import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shg_app/l10n/app_localizations.dart';
import '../../providers/riverpod_providers.dart';
import '../../config/theme.dart';
import '../../config/routes.dart';
import '../../models/loan.dart';

class LoansDashboardScreen extends ConsumerStatefulWidget {
  const LoansDashboardScreen({super.key});

  @override
  ConsumerState<LoansDashboardScreen> createState() => _LoansDashboardScreenState();
}

class _LoansDashboardScreenState extends ConsumerState<LoansDashboardScreen> {
  String? _selectedFilter;

  List<Loan> _filterLoans(List<Loan> loans) {
    if (_selectedFilter == null) {
      return loans;
    }
    return loans.where((l) => l.status == _selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final group = ref.watch(groupProvider).currentGroup;
    final loansAsync = group != null ? ref.watch(loansProvider(group.id)) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loans),
        elevation: 0,
      ),
      body: loansAsync == null
          ? Center(child: Text(l10n.empty_state))
          : RefreshIndicator(
              onRefresh: () async {
                if (group != null) {
                  ref.invalidate(loansProvider(group.id));
                }
              },
              child: loansAsync.when(
                data: (loans) {
                  if (loans.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.empty_state,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    );
                  }

                  final filteredLoans = _filterLoans(loans);
                  
                  // Calculate stats based on ALL loans (not filtered)
                  final requestedLoans = loans.where((l) => l.status == 'REQUESTED').length;
                  final approvedLoans = loans.where((l) => l.status == 'APPROVED').length;
                  final declinedLoans = loans.where((l) => l.status == 'REJECTED').length;
                  final totalAmountApproved = loans
                      .where((l) => l.status == 'APPROVED')
                      .fold<double>(
                        0,
                        (sum, l) => sum + (l.approvedAmount ?? l.requestedAmount),
                      );

                  return Column(
                    children: [
                      // Statistics Cards
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.1,
                          children: [
                            _buildStatCard(
                              context,
                              'Requested Loans',
                              requestedLoans.toString(),
                              Icons.schedule,
                              Colors.orange,
                            ),
                            _buildStatCard(
                              context,
                              'Approved Loans',
                              approvedLoans.toString(),
                              Icons.check_circle,
                              AppTheme.primaryGreen,
                            ),
                            _buildStatCard(
                              context,
                              'Declined Loans',
                              declinedLoans.toString(),
                              Icons.cancel,
                              Colors.red,
                            ),
                            _buildStatCard(
                              context,
                              'Amount Approved',
                              '₹${totalAmountApproved.toStringAsFixed(0)}',
                              Icons.currency_rupee,
                              AppTheme.primaryGreen,
                            ),
                          ],
                        ),
                      ),
                      // Filter Chips
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              FilterChip(
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
                                label: Text(l10n.pending),
                                showCheckmark: false,
                                selected: _selectedFilter == 'REQUESTED',
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = selected ? 'REQUESTED' : null;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              FilterChip(
                                label: const Text('Approved'),
                                showCheckmark: false,
                                selected: _selectedFilter == 'APPROVED',
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = selected ? 'APPROVED' : null;
                                  });
                                },
                              ),
                              const SizedBox(width: 8),
                              FilterChip(
                                label: const Text('Declined'),
                                showCheckmark: false,
                                selected: _selectedFilter == 'REJECTED',
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedFilter = selected ? 'REJECTED' : null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1),
                      // Loans List
                      Expanded(
                        child: filteredLoans.isEmpty
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
                                itemCount: filteredLoans.length,
                                itemBuilder: (context, index) {
                                  return _buildLoanCard(context, filteredLoans[index]);
                                },
                              ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Error: $err',
                        style: TextStyle(color: Colors.red[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AppRoutes.requestLoan);
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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                          letterSpacing: 0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: color,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoanCard(BuildContext context, Loan loan) {
    final statusColor = _getStatusColor(loan.status);
    // Always use requestedAmount, fallback to approvedAmount if requestedAmount is 0
    final amount = loan.requestedAmount > 0 ? loan.requestedAmount : (loan.approvedAmount ?? 0);
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.loanDetail, arguments: loan.id);
        },
        borderRadius: BorderRadius.circular(12),
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
                        Text(
                          loan.borrowerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          loan.purpose,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      loan.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '₹${amount.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'REQUESTED':
        return Colors.orange;
      case 'APPROVED':
        return AppTheme.primaryGreen;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
