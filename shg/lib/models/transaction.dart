class Transaction {
  final String id;
  final String groupId;
  final String type;
  final double amount;
  final DateTime date;
  final String category;
  final String? memberId;
  final String notes;
  final String receiptUrl;
  final String createdBy;

  Transaction({
    required this.id,
    required this.groupId,
    required this.type,
    required this.amount,
    required this.date,
    required this.category,
    this.memberId,
    required this.notes,
    required this.receiptUrl,
    required this.createdBy,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Handle both description and notes fields
    final notes = json['notes'] ?? json['description'] ?? '';
    return Transaction(
      id: json['id'] ?? json['_id'] ?? '',
      groupId: json['groupId'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      category: json['category'] ?? '',
      memberId: json['memberId'] ?? json['userId']?['_id'] ?? json['userId']?.toString() ?? '',
      notes: notes,
      receiptUrl: json['receiptUrl'] ?? '',
      createdBy: json['createdBy'] ?? json['userId']?['_id'] ?? json['userId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'category': category,
      'memberId': memberId,
      'notes': notes,
      'receiptUrl': receiptUrl,
    };
  }
}
