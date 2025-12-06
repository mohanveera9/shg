import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../services/api_service.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  late Future<Map<String, dynamic>> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _fetchProduct();
  }

  Future<Map<String, dynamic>> _fetchProduct() async {
    final apiService = ref.read(apiServiceProvider);
    return apiService.get('/products/detail/${widget.productId}', needsAuth: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.data!['success']) {
            return Center(
              child: Text('Error: ${snapshot.error ?? snapshot.data!['message']}'),
            );
          }

          final product = snapshot.data!['product'];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                height: 250,
                decoration: BoxDecoration(
                  color: AppTheme.lightGreen.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: product['photoUrl'] != null
                    ? Image.network(product['photoUrl'], fit: BoxFit.cover)
                    : Icon(Icons.image, size: 96, color: Colors.grey[400]),
              ),
              const SizedBox(height: 24),
              Text(
                product['title'] ?? '',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                product['description'] ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '₹${product['price'].toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppTheme.primaryGreen),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Stock', style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 4),
                      Text(
                        '${product['stock']} units',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Created By', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      product['createdByName'] ?? 'Unknown',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/add-product', arguments: widget.productId),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Edit Product'),
              ),
            ],
          );
        },
      ),
    );
  }
}
