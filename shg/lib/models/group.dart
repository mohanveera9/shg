class Group {
  final String id;
  final String name;
  final String groupCode;
  final String groupId;
  final String? qrCode;
  final String village;
  final String block;
  final String district;
  final String createdBy;
  final List<GroupMember> members;
  final bool researchConsent;
  final double cashInHand;
  final double totalSavings;
  final String? userRole;

  Group({
    required this.id,
    required this.name,
    required this.groupCode,
    required this.groupId,
    this.qrCode,
    required this.village,
    required this.block,
    required this.district,
    required this.createdBy,
    required this.members,
    required this.researchConsent,
    required this.cashInHand,
    required this.totalSavings,
    this.userRole,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      groupCode: json['groupCode'] ?? '',
      groupId: json['groupId'] ?? '',
      qrCode: json['qrCode'],
      village: json['village'] ?? '',
      block: json['block'] ?? '',
      district: json['district'] ?? '',
      createdBy: json['createdBy'] ?? '',
      members: (json['members'] as List<dynamic>?)
          ?.map((m) => GroupMember.fromJson(m))
          .toList() ?? [],
      researchConsent: json['researchConsent'] ?? false,
      cashInHand: (json['cashInHand'] ?? 0).toDouble(),
      totalSavings: (json['totalSavings'] ?? 0).toDouble(),
      userRole: json['userRole'],
    );
  }
}

class GroupMember {
  final String userId;
  final String role;
  final DateTime joinedAt;
  final String status;

  GroupMember({
    required this.userId,
    required this.role,
    required this.joinedAt,
    required this.status,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) {
    return GroupMember(
      userId: json['userId'] ?? '',
      role: json['role'] ?? 'MEMBER',
      joinedAt: json['joinedAt'] != null 
          ? DateTime.parse(json['joinedAt']) 
          : DateTime.now(),
      status: json['status'] ?? 'ACTIVE',
    );
  }
}
