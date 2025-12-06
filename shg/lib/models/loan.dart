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
    return Loan(
      id: json['_id'] ?? json['id'] ?? '',
      groupId: json['groupId'] ?? '',
      borrowerId: json['borrowerId']?['_id'] ?? json['borrowerId'] ?? '',
      borrowerName: json['borrowerId']?['name'] ?? json['borrowerName'] ?? '',
      borrowerPhone: json['borrowerId']?['phone'] ?? json['borrowerPhone'] ?? '',
      status: json['status'] ?? '',
      requestedAmount: (json['requestedAmount'] ?? 0.0).toDouble(),
      approvedAmount: json['approvedAmount']?.toDouble(),
      interestRate: json['interestRate']?.toDouble(),
      tenureMonths: json['tenureMonths'],
      emiAmount: json['emiAmount']?.toDouble(),
      totalPaid: (json['totalPaid'] ?? 0.0).toDouble(),
      remainingBalance: json['remainingBalance']?.toDouble(),
      purpose: json['purpose'] ?? '',
      requestDate: DateTime.parse(json['requestDate'] ?? DateTime.now().toIso8601String()),
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
