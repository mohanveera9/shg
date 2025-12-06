// GENERATED CODE - MANUALLY CREATED FOR DRIFT
// ignore_for_file: type=lint

part of 'database.dart';

class TransactionEntity extends DataClass implements Insertable<TransactionEntity> {
  final int id;
  final String? serverId;
  final String groupId;
  final String type;
  final double amount;
  final DateTime date;
  final String category;
  final String? memberId;
  final String? memberName;
  final String? notes;
  final String? receiptUrl;
  final bool pendingSync;
  final DateTime createdAt;

  const TransactionEntity({
    required this.id,
    this.serverId,
    required this.groupId,
    required this.type,
    required this.amount,
    required this.date,
    required this.category,
    this.memberId,
    this.memberName,
    this.notes,
    this.receiptUrl,
    required this.pendingSync,
    required this.createdAt,
  });

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || serverId != null) {
      map['server_id'] = Variable<String?>(serverId);
    }
    map['group_id'] = Variable<String>(groupId);
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String?>(memberId);
    }
    if (!nullToAbsent || memberName != null) {
      map['member_name'] = Variable<String?>(memberName);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String?>(notes);
    }
    if (!nullToAbsent || receiptUrl != null) {
      map['receipt_url'] = Variable<String?>(receiptUrl);
    }
    map['pending_sync'] = Variable<bool>(pendingSync);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      serverId: serverId == null && nullToAbsent ? const Value.absent() : Value(serverId),
      groupId: Value(groupId),
      type: Value(type),
      amount: Value(amount),
      date: Value(date),
      category: Value(category),
      memberId: memberId == null && nullToAbsent ? const Value.absent() : Value(memberId),
      memberName: memberName == null && nullToAbsent ? const Value.absent() : Value(memberName),
      notes: notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      receiptUrl: receiptUrl == null && nullToAbsent ? const Value.absent() : Value(receiptUrl),
      pendingSync: Value(pendingSync),
      createdAt: Value(createdAt),
    );
  }

  factory TransactionEntity.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntity(
      id: serializer.fromJson<int>(json['id']),
      serverId: serializer.fromJson<String?>(json['serverId']),
      groupId: serializer.fromJson<String>(json['groupId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      category: serializer.fromJson<String>(json['category']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      memberName: serializer.fromJson<String?>(json['memberName']),
      notes: serializer.fromJson<String?>(json['notes']),
      receiptUrl: serializer.fromJson<String?>(json['receiptUrl']),
      pendingSync: serializer.fromJson<bool>(json['pendingSync']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'serverId': serializer.toJson<String?>(serverId),
      'groupId': serializer.toJson<String>(groupId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'category': serializer.toJson<String>(category),
      'memberId': serializer.toJson<String?>(memberId),
      'memberName': serializer.toJson<String?>(memberName),
      'notes': serializer.toJson<String?>(notes),
      'receiptUrl': serializer.toJson<String?>(receiptUrl),
      'pendingSync': serializer.toJson<bool>(pendingSync),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransactionEntity copyWith({
    int? id,
    String? serverId,
    String? groupId,
    String? type,
    double? amount,
    DateTime? date,
    String? category,
    String? memberId,
    String? memberName,
    String? notes,
    String? receiptUrl,
    bool? pendingSync,
    DateTime? createdAt,
  }) => TransactionEntity(
        id: id ?? this.id,
        serverId: serverId ?? this.serverId,
        groupId: groupId ?? this.groupId,
        type: type ?? this.type,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        category: category ?? this.category,
        memberId: memberId ?? this.memberId,
        memberName: memberName ?? this.memberName,
        notes: notes ?? this.notes,
        receiptUrl: receiptUrl ?? this.receiptUrl,
        pendingSync: pendingSync ?? this.pendingSync,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  String toString() {
    return (StringBuffer('TransactionEntity(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('groupId: $groupId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('memberId: $memberId, ')
          ..write('memberName: $memberName, ')
          ..write('notes: $notes, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
        id,
        serverId,
        groupId,
        type,
        amount,
        date,
        category,
        memberId,
        memberName,
        notes,
        receiptUrl,
        pendingSync,
        createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntity &&
          other.id == id &&
          other.serverId == serverId &&
          other.groupId == groupId &&
          other.type == type &&
          other.amount == amount &&
          other.date == date &&
          other.category == category &&
          other.memberId == memberId &&
          other.memberName == memberName &&
          other.notes == notes &&
          other.receiptUrl == receiptUrl &&
          other.pendingSync == pendingSync &&
          other.createdAt == createdAt);
}

class TransactionsTableCompanion extends UpdateCompanion<TransactionEntity> {
  final Value<int> id;
  final Value<String?> serverId;
  final Value<String> groupId;
  final Value<String> type;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> category;
  final Value<String?> memberId;
  final Value<String?> memberName;
  final Value<String?> notes;
  final Value<String?> receiptUrl;
  final Value<bool> pendingSync;
  final Value<DateTime> createdAt;

  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    this.groupId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.category = const Value.absent(),
    this.memberId = const Value.absent(),
    this.memberName = const Value.absent(),
    this.notes = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.pendingSync = const Value.absent(),
    this.createdAt = const Value.absent(),
  });

  TransactionsTableCompanion.insert({
    this.id = const Value.absent(),
    this.serverId = const Value.absent(),
    required String groupId,
    required String type,
    required double amount,
    required DateTime date,
    required String category,
    this.memberId = const Value.absent(),
    this.memberName = const Value.absent(),
    this.notes = const Value.absent(),
    this.receiptUrl = const Value.absent(),
    this.pendingSync = const Value(true),
    Value<DateTime>? createdAt,
  })  : groupId = Value(groupId),
        type = Value(type),
        amount = Value(amount),
        date = Value(date),
        category = Value(category),
        createdAt = createdAt ?? Value(DateTime.now());

  static Insertable<TransactionEntity> custom({
    Expression<int>? id,
    Expression<String>? serverId,
    Expression<String>? groupId,
    Expression<String>? type,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? category,
    Expression<String>? memberId,
    Expression<String>? memberName,
    Expression<String>? notes,
    Expression<String>? receiptUrl,
    Expression<bool>? pendingSync,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (serverId != null) 'server_id': serverId,
      if (groupId != null) 'group_id': groupId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (category != null) 'category': category,
      if (memberId != null) 'member_id': memberId,
      if (memberName != null) 'member_name': memberName,
      if (notes != null) 'notes': notes,
      if (receiptUrl != null) 'receipt_url': receiptUrl,
      if (pendingSync != null) 'pending_sync': pendingSync,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<int>? id,
    Value<String?>? serverId,
    Value<String>? groupId,
    Value<String>? type,
    Value<double>? amount,
    Value<DateTime>? date,
    Value<String>? category,
    Value<String?>? memberId,
    Value<String?>? memberName,
    Value<String?>? notes,
    Value<String?>? receiptUrl,
    Value<bool>? pendingSync,
    Value<DateTime>? createdAt,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      serverId: serverId ?? this.serverId,
      groupId: groupId ?? this.groupId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      category: category ?? this.category,
      memberId: memberId ?? this.memberId,
      memberName: memberName ?? this.memberName,
      notes: notes ?? this.notes,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      pendingSync: pendingSync ?? this.pendingSync,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (serverId.present) {
      map['server_id'] = Variable<String?>(serverId.value);
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String?>(memberId.value);
    }
    if (memberName.present) {
      map['member_name'] = Variable<String?>(memberName.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String?>(notes.value);
    }
    if (receiptUrl.present) {
      map['receipt_url'] = Variable<String?>(receiptUrl.value);
    }
    if (pendingSync.present) {
      map['pending_sync'] = Variable<bool>(pendingSync.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('serverId: $serverId, ')
          ..write('groupId: $groupId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('category: $category, ')
          ..write('memberId: $memberId, ')
          ..write('memberName: $memberName, ')
          ..write('notes: $notes, ')
          ..write('receiptUrl: $receiptUrl, ')
          ..write('pendingSync: $pendingSync, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionEntity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);

  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    hasAutoIncrement: true,
    declaredAsPrimaryKey: true,
  );

  final VerificationMeta _serverIdMeta = const VerificationMeta('serverId');
  late final GeneratedColumn<String> serverId = GeneratedColumn<String>(
    'server_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );

  final VerificationMeta _groupIdMeta = const VerificationMeta('groupId');
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );

  final VerificationMeta _typeMeta = const VerificationMeta('type');
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );

  final VerificationMeta _amountMeta = const VerificationMeta('amount');
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
  );

  final VerificationMeta _dateMeta = const VerificationMeta('date');
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
  );

  final VerificationMeta _categoryMeta = const VerificationMeta('category');
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
  );

  final VerificationMeta _memberIdMeta = const VerificationMeta('memberId');
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );

  final VerificationMeta _memberNameMeta = const VerificationMeta('memberName');
  late final GeneratedColumn<String> memberName = GeneratedColumn<String>(
    'member_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );

  final VerificationMeta _notesMeta = const VerificationMeta('notes');
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );

  final VerificationMeta _receiptUrlMeta = const VerificationMeta('receiptUrl');
  late final GeneratedColumn<String> receiptUrl = GeneratedColumn<String>(
    'receipt_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
  );

  final VerificationMeta _pendingSyncMeta = const VerificationMeta('pendingSync');
  late final GeneratedColumn<bool> pendingSync = GeneratedColumn<bool>(
    'pending_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    defaultValue: const Constant(false),
  );

  final VerificationMeta _createdAtMeta = const VerificationMeta('createdAt');
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    defaultValue: currentDateAndTime,
  );

  @override
  List<GeneratedColumn> get $columns => [
        id,
        serverId,
        groupId,
        type,
        amount,
        date,
        category,
        memberId,
        memberName,
        notes,
        receiptUrl,
        pendingSync,
        createdAt,
      ];

  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => 'transactions_table';

  @override
  VerificationContext validateIntegrity(Insertable<TransactionEntity> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('server_id')) {
      context.handle(_serverIdMeta, serverId.isAcceptableOrUnknown(data['server_id']!, _serverIdMeta));
    }
    if (data.containsKey('group_id')) {
      context.handle(_groupIdMeta, groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta));
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta, amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(_dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta, category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(_memberIdMeta, memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta));
    }
    if (data.containsKey('member_name')) {
      context.handle(_memberNameMeta, memberName.isAcceptableOrUnknown(data['member_name']!, _memberNameMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(_notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('receipt_url')) {
      context.handle(_receiptUrlMeta, receiptUrl.isAcceptableOrUnknown(data['receipt_url']!, _receiptUrlMeta));
    }
    if (data.containsKey('pending_sync')) {
      context.handle(_pendingSyncMeta, pendingSync.isAcceptableOrUnknown(data['pending_sync']!, _pendingSyncMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta, createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};

  @override
  TransactionEntity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntity(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      serverId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}server_id']),
      groupId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}group_id'])!,
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      amount: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      category: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      memberId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}member_id']),
      memberName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}member_name']),
      notes: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}notes']),
      receiptUrl: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}receipt_url']),
      pendingSync: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}pending_sync'])!,
      createdAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $TransactionsTableTable transactionsTable = $TransactionsTableTable(this);

  @override
  Iterable<TableInfo<Table, Object?>> get allTables => [transactionsTable];
}
