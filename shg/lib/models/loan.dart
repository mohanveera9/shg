class Loan {
  final String id;
  final String groupId;
  final String borrowerId;
  final String borrowerName;
  final String borrowerPhone;
  final String status;
  final double requestedAmount;
  final double? approvedAmount;
  final double? interestRate;
  final int? tenureMonths;
  final double? emiAmount;
  final double totalPaid;
  final double? remainingBalance;
  final String purpose;
  final DateTime requestDate;
  final DateTime? approvalDate;
  final DateTime? disbursalDate;
  final List<dynamic>? documents;
  final String? notes;

  Loan({
    required this.id,
    required this.groupId,
    required this.borrowerId,
    required this.borrowerName,
    required this.borrowerPhone,
    required this.status,
    required this.requestedAmount,
    this.approvedAmount,
    this.interestRate,
    this.tenureMonths,
    this.emiAmount,
    required this.totalPaid,
    this.remainingBalance,
    required this.purpose,
    required this.requestDate,
    this.approvalDate,
    this.disbursalDate,
    this.documents,
    this.notes,
  });

  factory Loan.fromJson(Map<String, dynamic> json) {
    // Handle both tenure and tenureMonths, requestDate and createdAt
    final tenureMonths = json['tenureMonths'] ?? json['tenure'];
    final requestDateStr = json['requestDate'] ?? json['createdAt'] ?? DateTime.now().toIso8601String();
    
    // Calculate totalPaid from repayments if not provided
    double totalPaid = json['totalPaid']?.toDouble() ?? 0.0;
    if (json['repayments'] != null && totalPaid == 0.0) {
      final repayments = json['repayments'] as List?;
      if (repayments != null) {
        totalPaid = repayments
            .where((r) => r['status'] == 'PAID')
            .fold(0.0, (sum, r) => sum + ((r['amount'] ?? 0).toDouble()));
      }
    }
    
    // Calculate remainingBalance if not provided
    double? remainingBalance = json['remainingBalance']?.toDouble();
    if (remainingBalance == null && json['disbursedAmount'] != null) {
      final disbursedAmount = json['disbursedAmount'].toDouble();
      remainingBalance = disbursedAmount > 0 ? disbursedAmount - totalPaid : null;
    }
    
    return Loan(
      id: json['_id'] ?? json['id'] ?? '',
      groupId: json['groupId'] ?? '',
      borrowerId: json['borrowerId']?['_id'] ?? json['borrowerId']?.toString() ?? json['borrowerId'] ?? '',
      borrowerName: json['borrowerName'] ?? json['borrowerId']?['name'] ?? '',
      borrowerPhone: json['borrowerPhone'] ?? json['borrowerId']?['phone'] ?? '',
      status: json['status'] ?? '',
      requestedAmount: (json['requestedAmount'] ?? 0.0).toDouble(),
      approvedAmount: json['approvedAmount']?.toDouble(),
      interestRate: json['interestRate']?.toDouble(),
      tenureMonths: tenureMonths != null ? (tenureMonths is int ? tenureMonths : tenureMonths.toInt()) : null,
      emiAmount: json['emiAmount']?.toDouble(),
      totalPaid: totalPaid,
      remainingBalance: remainingBalance,
      purpose: json['purpose'] ?? '',
      requestDate: DateTime.parse(requestDateStr),
      approvalDate: json['approvalDate'] != null ? DateTime.parse(json['approvalDate']) : null,
      disbursalDate: json['disbursalDate'] != null ? DateTime.parse(json['disbursalDate']) : null,
      documents: json['documents'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'borrowerId': borrowerId,
      'borrowerName': borrowerName,
      'borrowerPhone': borrowerPhone,
      'status': status,
      'requestedAmount': requestedAmount,
      'approvedAmount': approvedAmount,
      'interestRate': interestRate,
      'tenureMonths': tenureMonths,
      'emiAmount': emiAmount,
      'totalPaid': totalPaid,
      'remainingBalance': remainingBalance,
      'purpose': purpose,
      'requestDate': requestDate.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'disbursalDate': disbursalDate?.toIso8601String(),
      'documents': documents,
      'notes': notes,
    };
  }
}

class LoanRepayment {
  final String id;
  final double amount;
  final DateTime paymentDate;
  final String paymentMethod;
  final String? paymentReference;
  final double? principal;
  final double? interest;

  LoanRepayment({
    required this.id,
    required this.amount,
    required this.paymentDate,
    required this.paymentMethod,
    this.paymentReference,
    this.principal,
    this.interest,
  });

  factory LoanRepayment.fromJson(Map<String, dynamic> json) {
    return LoanRepayment(
      id: json['_id'] ?? json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      paymentDate: DateTime.parse(json['paymentDate'] ?? DateTime.now().toIso8601String()),
      paymentMethod: json['paymentMethod'] ?? '',
      paymentReference: json['paymentReference'],
      principal: json['principal']?.toDouble(),
      interest: json['interest']?.toDouble(),
    );
  }
}
