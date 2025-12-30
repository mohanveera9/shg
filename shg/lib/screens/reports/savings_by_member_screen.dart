import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';

class SavingsByMemberScreen extends ConsumerStatefulWidget {
  const SavingsByMemberScreen({super.key});

  @override
  ConsumerState<SavingsByMemberScreen> createState() => _SavingsByMemberScreenState();
}

class _SavingsByMemberScreenState extends ConsumerState<SavingsByMemberScreen> {
  late Future<Map<String, dynamic>> _savingsFuture;

  @override
  void initState() {
    super.initState();
    _savingsFuture = _fetchSavings();
  }

  Future<Map<String, dynamic>> _fetchSavings() async {
    final group = ref.read(groupProvider).currentGroup;
    if (group == null) throw Exception('No group selected');

    final apiService = ref.read(apiServiceProvider);
    return apiService.get('/savings/${group.id}', needsAuth: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Savings by Member'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _savingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.data!['success']) {
            return Center(
              child: Text('Error: ${snapshot.error ?? snapshot.data!['message']}'),
            );
          }

          final data = snapshot.data!;
          final savings = data['savingsByMember'] ?? [];
          final totalSavings = data['groupTotalSavings'] ?? 0;

          if (savings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.savings, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No savings data', style: Theme.of(context).textTheme.titleLarge),
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
                      Text('Total Group Savings', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      Text(
                        '₹${totalSavings.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Member Savings', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ...savings.map<Widget>((member) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(member['memberName']?[0] ?? 'M'),
                  ),
                  title: Text(member['memberName'] ?? 'Unknown'),
                  subtitle: Text(member['memberPhone'] ?? ''),
                  trailing: Text(
                    '₹${member['amount'].toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              )).toList(),
            ],
          );
        },
      ),
    );
  }
}
