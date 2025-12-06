import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';
import '../../services/api_service.dart';

class DisburseLoanScreen extends ConsumerStatefulWidget {
  final String loanId;

  const DisburseLoanScreen({super.key, required this.loanId});

  @override
  ConsumerState<DisburseLoanScreen> createState() => _DisburseLoanScreenState();
}

class _DisburseLoanScreenState extends ConsumerState<DisburseLoanScreen> {
  final _dateController = TextEditingController();
  final _referenceController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _dateController.dispose();
    _referenceController.dispose();
    super.dispose();
  }

  Future<void> _submitDisbursal() async {
    if (_dateController.text.isEmpty || _referenceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final apiService = ref.read(apiServiceProvider);
      final response = await apiService.put(
        '/loans/${widget.loanId}/disburse',
        {
          'disbursalDate': _dateController.text,
          'paymentMethod': 'DUMMY_UPI',
          'paymentReference': _referenceController.text,
        },
        needsAuth: true,
      );

      if (response['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Loan disbursed successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        throw Exception(response['message'] ?? 'Failed to disburse loan');
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

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2050),
    );
    if (picked != null) {
      _dateController.text = picked.toIso8601String().split('T')[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disburse Loan'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Disbursal Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _dateController,
            readOnly: true,
            onTap: _selectDate,
            decoration: InputDecoration(
              labelText: 'Disbursal Date',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.calendar_today),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _referenceController,
            decoration: InputDecoration(
              labelText: 'Payment Reference',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              prefixIcon: const Icon(Icons.receipt),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isLoading ? null : _submitDisbursal,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isLoading
                ? const CircularProgressIndicator()
                : const Text('Confirm Disbursal'),
          ),
        ],
      ),
    );
  }
}
