class OrderModel {
  final String id;
  final String groupId;
  final String productId;
  final String productTitle;
  final String customerId;
  final String customerName;
  final String customerPhone;
  final int quantity;
  final double totalAmount;
  final String status;
  final DateTime orderDate;
  final DateTime? deliveryDate;

  OrderModel({
    required this.id,
    required this.groupId,
    required this.productId,
    required this.productTitle,
    required this.customerId,
    required this.customerName,
    required this.customerPhone,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.orderDate,
    this.deliveryDate,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    // Handle both createdAt and orderDate fields
    final orderDateStr = json['orderDate'] ?? json['createdAt'] ?? DateTime.now().toIso8601String();
    return OrderModel(
      id: json['_id'] ?? json['id'] ?? '',
      groupId: json['groupId'] ?? '',
      productId: json['productId']?['_id'] ?? json['productId']?.toString() ?? json['productId'] ?? '',
      productTitle: json['productTitle'] ?? json['productId']?['title'] ?? '',
      customerId: json['customerId']?['_id'] ?? json['customerId']?.toString() ?? json['customerId'] ?? '',
      customerName: json['customerName'] ?? json['customerId']?['name'] ?? '',
      customerPhone: json['customerPhone'] ?? json['customerId']?['phone'] ?? '',
      quantity: json['quantity'] ?? 0,
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'PENDING',
      orderDate: DateTime.parse(orderDateStr),
      deliveryDate: json['deliveryDate'] != null ? DateTime.parse(json['deliveryDate']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'customerId': customerId,
      'quantity': quantity,
      'totalAmount': totalAmount,
      'status': status,
      'orderDate': orderDate.toIso8601String(),
      'deliveryDate': deliveryDate?.toIso8601String(),
    };
  }

  OrderModel copyWith({
    String? status,
    DateTime? deliveryDate,
  }) {
    return OrderModel(
      id: id,
      groupId: groupId,
      productId: productId,
      productTitle: productTitle,
      customerId: customerId,
      customerName: customerName,
      customerPhone: customerPhone,
      quantity: quantity,
      totalAmount: totalAmount,
      status: status ?? this.status,
      orderDate: orderDate,
      deliveryDate: deliveryDate ?? this.deliveryDate,
    );
  }
}
