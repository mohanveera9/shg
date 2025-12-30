import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';

class ApproveLoanScreen extends ConsumerStatefulWidget {
  final String loanId;

  const ApproveLoanScreen({super.key, required this.loanId});

  @override
  ConsumerState<ApproveLoanScreen> createState() => _ApproveLoanScreenState();
}

class _ApproveLoanScreenState extends ConsumerState<ApproveLoanScreen> {
  final _approvedAmountController = TextEditingController();
  final _interestRateController = TextEditingController();
  final _tenureController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _approvedAmountController.dispose();
    _interestRateController.dispose();
    _tenureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitApproval() async {
    if (_approvedAmountController.text.isEmpty || _interestRateController.text.isEmpty || _tenureController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.put(
        '/loans/${widget.loanId}/approve',
        {
          'approvedAmount': double.parse(_approvedAmountController.text),
          'interestRate': double.parse(_interestRateController.text),
          'tenureMonths': int.parse(_tenureController.text),
          'notes': _notesController.text,
        },
        needsAuth: true,
      );

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Loan approved successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to approve loan');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve Loan'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Loan Approval Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _approvedAmountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Approved Amount (₹)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.attach_money),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _interestRateController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'Interest Rate (%)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.percent),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _tenureController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Tenure (Months)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.calendar_month),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.note),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitApproval,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Approve Loan'),
          ),
        ],
      ),
    );
  }
}
