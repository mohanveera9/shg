class Product {
  final String id;
  final String groupId;
  final String title;
  final String description;
  final double price;
  final int stock;
  final String? photoUrl;
  final String createdBy;
  final String createdByName;
  final DateTime createdAt;

  Product({
    required this.id,
    required this.groupId,
    required this.title,
    required this.description,
    required this.price,
    required this.stock,
    this.photoUrl,
    required this.createdBy,
    required this.createdByName,
    required this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? json['id'] ?? '',
      groupId: json['groupId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      stock: json['stock'] ?? 0,
      photoUrl: json['photoUrl'],
      createdBy: json['createdBy']?['_id'] ?? json['createdBy'] ?? '',
      createdByName: json['createdBy']?['name'] ?? json['createdByName'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'stock': stock,
      'photoUrl': photoUrl,
    };
  }

  Product copyWith({
    String? id,
    String? groupId,
    String? title,
    String? description,
    double? price,
    int? stock,
    String? photoUrl,
    String? createdBy,
    String? createdByName,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      photoUrl: photoUrl ?? this.photoUrl,
      createdBy: createdBy ?? this.createdBy,
      createdByName: createdByName ?? this.createdByName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
