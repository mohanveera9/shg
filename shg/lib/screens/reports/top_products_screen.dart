import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/riverpod_providers.dart';

class TopProductsScreen extends ConsumerStatefulWidget {
  const TopProductsScreen({super.key});

  @override
  ConsumerState<TopProductsScreen> createState() => _TopProductsScreenState();
}

class _TopProductsScreenState extends ConsumerState<TopProductsScreen> {
  late Future<Map<String, dynamic>> _topProductsFuture;

  @override
  void initState() {
    super.initState();
    _topProductsFuture = _fetchTopProducts();
  }

  Future<Map<String, dynamic>> _fetchTopProducts() async {
    final group = ref.read(groupProvider).currentGroup;
    if (group == null) throw Exception('No group selected');

    final apiService = ref.read(apiServiceProvider);
    return apiService.get('/reports/${group.id}/top-products', needsAuth: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Products'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _topProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            final products = ref.watch(groupProvider).currentGroup != null
                ? ref.watch(productsProvider(ref.watch(groupProvider).currentGroup!.id)).value ?? []
                : [];

            if (products.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text('No products yet', style: Theme.of(context).textTheme.titleLarge),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: products.asMap().entries.map<Widget>((entry) {
                final index = entry.key + 1;
                final product = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('#$index', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    title: Text(product.title),
                    subtitle: Text('₹${product.price.toStringAsFixed(0)}'),
                    trailing: Text('Stock: ${product.stock}'),
                  ),
                );
              }).toList(),
            );
          }

          final data = snapshot.data!;
          final products = data['topProducts'] ?? [];

          if (products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('No sales data', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: products.asMap().entries.map<Widget>((entry) {
              final index = entry.key + 1;
              final product = entry.value;
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text('#$index', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  title: Text(product['title'] ?? 'Unknown'),
                  subtitle: Text('Sales: ${product['sales'] ?? 0} units'),
                  trailing: Text('₹${product['revenue']?.toStringAsFixed(0) ?? '0'}'),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
