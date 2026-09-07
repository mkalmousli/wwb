// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $WebsitesTable extends Websites with TableInfo<$WebsitesTable, Website> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WebsitesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _firstSeenAtMeta = const VerificationMeta(
    'firstSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> firstSeenAt = GeneratedColumn<DateTime>(
    'first_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _starredMeta = const VerificationMeta(
    'starred',
  );
  @override
  late final GeneratedColumn<bool> starred = GeneratedColumn<bool>(
    'starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _starredAtMeta = const VerificationMeta(
    'starredAt',
  );
  @override
  late final GeneratedColumn<DateTime> starredAt = GeneratedColumn<DateTime>(
    'starred_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    url,
    title,
    firstSeenAt,
    starred,
    starredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'websites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Website> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('first_seen_at')) {
      context.handle(
        _firstSeenAtMeta,
        firstSeenAt.isAcceptableOrUnknown(
          data['first_seen_at']!,
          _firstSeenAtMeta,
        ),
      );
    }
    if (data.containsKey('starred')) {
      context.handle(
        _starredMeta,
        starred.isAcceptableOrUnknown(data['starred']!, _starredMeta),
      );
    }
    if (data.containsKey('starred_at')) {
      context.handle(
        _starredAtMeta,
        starredAt.isAcceptableOrUnknown(data['starred_at']!, _starredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Website map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Website(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      firstSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}first_seen_at'],
      )!,
      starred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}starred'],
      )!,
      starredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starred_at'],
      ),
    );
  }

  @override
  $WebsitesTable createAlias(String alias) {
    return $WebsitesTable(attachedDatabase, alias);
  }
}

class Website extends DataClass implements Insertable<Website> {
  final int id;
  final String url;
  final String? title;
  final DateTime firstSeenAt;
  final bool starred;
  final DateTime? starredAt;
  const Website({
    required this.id,
    required this.url,
    this.title,
    required this.firstSeenAt,
    required this.starred,
    this.starredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['first_seen_at'] = Variable<DateTime>(firstSeenAt);
    map['starred'] = Variable<bool>(starred);
    if (!nullToAbsent || starredAt != null) {
      map['starred_at'] = Variable<DateTime>(starredAt);
    }
    return map;
  }

  WebsitesCompanion toCompanion(bool nullToAbsent) {
    return WebsitesCompanion(
      id: Value(id),
      url: Value(url),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      firstSeenAt: Value(firstSeenAt),
      starred: Value(starred),
      starredAt: starredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(starredAt),
    );
  }

  factory Website.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Website(
      id: serializer.fromJson<int>(json['id']),
      url: serializer.fromJson<String>(json['url']),
      title: serializer.fromJson<String?>(json['title']),
      firstSeenAt: serializer.fromJson<DateTime>(json['firstSeenAt']),
      starred: serializer.fromJson<bool>(json['starred']),
      starredAt: serializer.fromJson<DateTime?>(json['starredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'url': serializer.toJson<String>(url),
      'title': serializer.toJson<String?>(title),
      'firstSeenAt': serializer.toJson<DateTime>(firstSeenAt),
      'starred': serializer.toJson<bool>(starred),
      'starredAt': serializer.toJson<DateTime?>(starredAt),
    };
  }

  Website copyWith({
    int? id,
    String? url,
    Value<String?> title = const Value.absent(),
    DateTime? firstSeenAt,
    bool? starred,
    Value<DateTime?> starredAt = const Value.absent(),
  }) => Website(
    id: id ?? this.id,
    url: url ?? this.url,
    title: title.present ? title.value : this.title,
    firstSeenAt: firstSeenAt ?? this.firstSeenAt,
    starred: starred ?? this.starred,
    starredAt: starredAt.present ? starredAt.value : this.starredAt,
  );
  Website copyWithCompanion(WebsitesCompanion data) {
    return Website(
      id: data.id.present ? data.id.value : this.id,
      url: data.url.present ? data.url.value : this.url,
      title: data.title.present ? data.title.value : this.title,
      firstSeenAt: data.firstSeenAt.present
          ? data.firstSeenAt.value
          : this.firstSeenAt,
      starred: data.starred.present ? data.starred.value : this.starred,
      starredAt: data.starredAt.present ? data.starredAt.value : this.starredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Website(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('starred: $starred, ')
          ..write('starredAt: $starredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, url, title, firstSeenAt, starred, starredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Website &&
          other.id == this.id &&
          other.url == this.url &&
          other.title == this.title &&
          other.firstSeenAt == this.firstSeenAt &&
          other.starred == this.starred &&
          other.starredAt == this.starredAt);
}

class WebsitesCompanion extends UpdateCompanion<Website> {
  final Value<int> id;
  final Value<String> url;
  final Value<String?> title;
  final Value<DateTime> firstSeenAt;
  final Value<bool> starred;
  final Value<DateTime?> starredAt;
  const WebsitesCompanion({
    this.id = const Value.absent(),
    this.url = const Value.absent(),
    this.title = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.starred = const Value.absent(),
    this.starredAt = const Value.absent(),
  });
  WebsitesCompanion.insert({
    this.id = const Value.absent(),
    required String url,
    this.title = const Value.absent(),
    this.firstSeenAt = const Value.absent(),
    this.starred = const Value.absent(),
    this.starredAt = const Value.absent(),
  }) : url = Value(url);
  static Insertable<Website> custom({
    Expression<int>? id,
    Expression<String>? url,
    Expression<String>? title,
    Expression<DateTime>? firstSeenAt,
    Expression<bool>? starred,
    Expression<DateTime>? starredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (url != null) 'url': url,
      if (title != null) 'title': title,
      if (firstSeenAt != null) 'first_seen_at': firstSeenAt,
      if (starred != null) 'starred': starred,
      if (starredAt != null) 'starred_at': starredAt,
    });
  }

  WebsitesCompanion copyWith({
    Value<int>? id,
    Value<String>? url,
    Value<String?>? title,
    Value<DateTime>? firstSeenAt,
    Value<bool>? starred,
    Value<DateTime?>? starredAt,
  }) {
    return WebsitesCompanion(
      id: id ?? this.id,
      url: url ?? this.url,
      title: title ?? this.title,
      firstSeenAt: firstSeenAt ?? this.firstSeenAt,
      starred: starred ?? this.starred,
      starredAt: starredAt ?? this.starredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (firstSeenAt.present) {
      map['first_seen_at'] = Variable<DateTime>(firstSeenAt.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    if (starredAt.present) {
      map['starred_at'] = Variable<DateTime>(starredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WebsitesCompanion(')
          ..write('id: $id, ')
          ..write('url: $url, ')
          ..write('title: $title, ')
          ..write('firstSeenAt: $firstSeenAt, ')
          ..write('starred: $starred, ')
          ..write('starredAt: $starredAt')
          ..write(')'))
        .toString();
  }
}

class $SnapshotsTable extends Snapshots
    with TableInfo<$SnapshotsTable, Snapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _websiteIdMeta = const VerificationMeta(
    'websiteId',
  );
  @override
  late final GeneratedColumn<int> websiteId = GeneratedColumn<int>(
    'website_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES websites (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<String> timestamp = GeneratedColumn<String>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalUrlMeta = const VerificationMeta(
    'originalUrl',
  );
  @override
  late final GeneratedColumn<String> originalUrl = GeneratedColumn<String>(
    'original_url',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusCodeMeta = const VerificationMeta(
    'statusCode',
  );
  @override
  late final GeneratedColumn<int> statusCode = GeneratedColumn<int>(
    'status_code',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _starredMeta = const VerificationMeta(
    'starred',
  );
  @override
  late final GeneratedColumn<bool> starred = GeneratedColumn<bool>(
    'starred',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("starred" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _starredAtMeta = const VerificationMeta(
    'starredAt',
  );
  @override
  late final GeneratedColumn<DateTime> starredAt = GeneratedColumn<DateTime>(
    'starred_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    websiteId,
    timestamp,
    originalUrl,
    statusCode,
    mimeType,
    starred,
    starredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<Snapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('website_id')) {
      context.handle(
        _websiteIdMeta,
        websiteId.isAcceptableOrUnknown(data['website_id']!, _websiteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_websiteIdMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('original_url')) {
      context.handle(
        _originalUrlMeta,
        originalUrl.isAcceptableOrUnknown(
          data['original_url']!,
          _originalUrlMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalUrlMeta);
    }
    if (data.containsKey('status_code')) {
      context.handle(
        _statusCodeMeta,
        statusCode.isAcceptableOrUnknown(data['status_code']!, _statusCodeMeta),
      );
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('starred')) {
      context.handle(
        _starredMeta,
        starred.isAcceptableOrUnknown(data['starred']!, _starredMeta),
      );
    }
    if (data.containsKey('starred_at')) {
      context.handle(
        _starredAtMeta,
        starredAt.isAcceptableOrUnknown(data['starred_at']!, _starredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {websiteId, timestamp},
  ];
  @override
  Snapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Snapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      websiteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}website_id'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timestamp'],
      )!,
      originalUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}original_url'],
      )!,
      statusCode: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status_code'],
      ),
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      starred: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}starred'],
      )!,
      starredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starred_at'],
      ),
    );
  }

  @override
  $SnapshotsTable createAlias(String alias) {
    return $SnapshotsTable(attachedDatabase, alias);
  }
}

class Snapshot extends DataClass implements Insertable<Snapshot> {
  final int id;
  final int websiteId;
  final String timestamp;
  final String originalUrl;
  final int? statusCode;
  final String? mimeType;
  final bool starred;
  final DateTime? starredAt;
  const Snapshot({
    required this.id,
    required this.websiteId,
    required this.timestamp,
    required this.originalUrl,
    this.statusCode,
    this.mimeType,
    required this.starred,
    this.starredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['website_id'] = Variable<int>(websiteId);
    map['timestamp'] = Variable<String>(timestamp);
    map['original_url'] = Variable<String>(originalUrl);
    if (!nullToAbsent || statusCode != null) {
      map['status_code'] = Variable<int>(statusCode);
    }
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['starred'] = Variable<bool>(starred);
    if (!nullToAbsent || starredAt != null) {
      map['starred_at'] = Variable<DateTime>(starredAt);
    }
    return map;
  }

  SnapshotsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotsCompanion(
      id: Value(id),
      websiteId: Value(websiteId),
      timestamp: Value(timestamp),
      originalUrl: Value(originalUrl),
      statusCode: statusCode == null && nullToAbsent
          ? const Value.absent()
          : Value(statusCode),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      starred: Value(starred),
      starredAt: starredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(starredAt),
    );
  }

  factory Snapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Snapshot(
      id: serializer.fromJson<int>(json['id']),
      websiteId: serializer.fromJson<int>(json['websiteId']),
      timestamp: serializer.fromJson<String>(json['timestamp']),
      originalUrl: serializer.fromJson<String>(json['originalUrl']),
      statusCode: serializer.fromJson<int?>(json['statusCode']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      starred: serializer.fromJson<bool>(json['starred']),
      starredAt: serializer.fromJson<DateTime?>(json['starredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'websiteId': serializer.toJson<int>(websiteId),
      'timestamp': serializer.toJson<String>(timestamp),
      'originalUrl': serializer.toJson<String>(originalUrl),
      'statusCode': serializer.toJson<int?>(statusCode),
      'mimeType': serializer.toJson<String?>(mimeType),
      'starred': serializer.toJson<bool>(starred),
      'starredAt': serializer.toJson<DateTime?>(starredAt),
    };
  }

  Snapshot copyWith({
    int? id,
    int? websiteId,
    String? timestamp,
    String? originalUrl,
    Value<int?> statusCode = const Value.absent(),
    Value<String?> mimeType = const Value.absent(),
    bool? starred,
    Value<DateTime?> starredAt = const Value.absent(),
  }) => Snapshot(
    id: id ?? this.id,
    websiteId: websiteId ?? this.websiteId,
    timestamp: timestamp ?? this.timestamp,
    originalUrl: originalUrl ?? this.originalUrl,
    statusCode: statusCode.present ? statusCode.value : this.statusCode,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    starred: starred ?? this.starred,
    starredAt: starredAt.present ? starredAt.value : this.starredAt,
  );
  Snapshot copyWithCompanion(SnapshotsCompanion data) {
    return Snapshot(
      id: data.id.present ? data.id.value : this.id,
      websiteId: data.websiteId.present ? data.websiteId.value : this.websiteId,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      originalUrl: data.originalUrl.present
          ? data.originalUrl.value
          : this.originalUrl,
      statusCode: data.statusCode.present
          ? data.statusCode.value
          : this.statusCode,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      starred: data.starred.present ? data.starred.value : this.starred,
      starredAt: data.starredAt.present ? data.starredAt.value : this.starredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Snapshot(')
          ..write('id: $id, ')
          ..write('websiteId: $websiteId, ')
          ..write('timestamp: $timestamp, ')
          ..write('originalUrl: $originalUrl, ')
          ..write('statusCode: $statusCode, ')
          ..write('mimeType: $mimeType, ')
          ..write('starred: $starred, ')
          ..write('starredAt: $starredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    websiteId,
    timestamp,
    originalUrl,
    statusCode,
    mimeType,
    starred,
    starredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Snapshot &&
          other.id == this.id &&
          other.websiteId == this.websiteId &&
          other.timestamp == this.timestamp &&
          other.originalUrl == this.originalUrl &&
          other.statusCode == this.statusCode &&
          other.mimeType == this.mimeType &&
          other.starred == this.starred &&
          other.starredAt == this.starredAt);
}

class SnapshotsCompanion extends UpdateCompanion<Snapshot> {
  final Value<int> id;
  final Value<int> websiteId;
  final Value<String> timestamp;
  final Value<String> originalUrl;
  final Value<int?> statusCode;
  final Value<String?> mimeType;
  final Value<bool> starred;
  final Value<DateTime?> starredAt;
  const SnapshotsCompanion({
    this.id = const Value.absent(),
    this.websiteId = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.originalUrl = const Value.absent(),
    this.statusCode = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.starred = const Value.absent(),
    this.starredAt = const Value.absent(),
  });
  SnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required int websiteId,
    required String timestamp,
    required String originalUrl,
    this.statusCode = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.starred = const Value.absent(),
    this.starredAt = const Value.absent(),
  }) : websiteId = Value(websiteId),
       timestamp = Value(timestamp),
       originalUrl = Value(originalUrl);
  static Insertable<Snapshot> custom({
    Expression<int>? id,
    Expression<int>? websiteId,
    Expression<String>? timestamp,
    Expression<String>? originalUrl,
    Expression<int>? statusCode,
    Expression<String>? mimeType,
    Expression<bool>? starred,
    Expression<DateTime>? starredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (websiteId != null) 'website_id': websiteId,
      if (timestamp != null) 'timestamp': timestamp,
      if (originalUrl != null) 'original_url': originalUrl,
      if (statusCode != null) 'status_code': statusCode,
      if (mimeType != null) 'mime_type': mimeType,
      if (starred != null) 'starred': starred,
      if (starredAt != null) 'starred_at': starredAt,
    });
  }

  SnapshotsCompanion copyWith({
    Value<int>? id,
    Value<int>? websiteId,
    Value<String>? timestamp,
    Value<String>? originalUrl,
    Value<int?>? statusCode,
    Value<String?>? mimeType,
    Value<bool>? starred,
    Value<DateTime?>? starredAt,
  }) {
    return SnapshotsCompanion(
      id: id ?? this.id,
      websiteId: websiteId ?? this.websiteId,
      timestamp: timestamp ?? this.timestamp,
      originalUrl: originalUrl ?? this.originalUrl,
      statusCode: statusCode ?? this.statusCode,
      mimeType: mimeType ?? this.mimeType,
      starred: starred ?? this.starred,
      starredAt: starredAt ?? this.starredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (websiteId.present) {
      map['website_id'] = Variable<int>(websiteId.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<String>(timestamp.value);
    }
    if (originalUrl.present) {
      map['original_url'] = Variable<String>(originalUrl.value);
    }
    if (statusCode.present) {
      map['status_code'] = Variable<int>(statusCode.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (starred.present) {
      map['starred'] = Variable<bool>(starred.value);
    }
    if (starredAt.present) {
      map['starred_at'] = Variable<DateTime>(starredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('websiteId: $websiteId, ')
          ..write('timestamp: $timestamp, ')
          ..write('originalUrl: $originalUrl, ')
          ..write('statusCode: $statusCode, ')
          ..write('mimeType: $mimeType, ')
          ..write('starred: $starred, ')
          ..write('starredAt: $starredAt')
          ..write(')'))
        .toString();
  }
}

class $SearchProvidersTable extends SearchProviders
    with TableInfo<$SearchProvidersTable, SearchProvider> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SearchProvidersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    key,
    displayName,
    enabled,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'search_providers';
  @override
  VerificationContext validateIntegrity(
    Insertable<SearchProvider> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SearchProvider map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SearchProvider(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SearchProvidersTable createAlias(String alias) {
    return $SearchProvidersTable(attachedDatabase, alias);
  }
}

class SearchProvider extends DataClass implements Insertable<SearchProvider> {
  final int id;
  final String key;
  final String displayName;
  final bool enabled;
  final int sortOrder;
  const SearchProvider({
    required this.id,
    required this.key,
    required this.displayName,
    required this.enabled,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['display_name'] = Variable<String>(displayName);
    map['enabled'] = Variable<bool>(enabled);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SearchProvidersCompanion toCompanion(bool nullToAbsent) {
    return SearchProvidersCompanion(
      id: Value(id),
      key: Value(key),
      displayName: Value(displayName),
      enabled: Value(enabled),
      sortOrder: Value(sortOrder),
    );
  }

  factory SearchProvider.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SearchProvider(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      displayName: serializer.fromJson<String>(json['displayName']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'displayName': serializer.toJson<String>(displayName),
      'enabled': serializer.toJson<bool>(enabled),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SearchProvider copyWith({
    int? id,
    String? key,
    String? displayName,
    bool? enabled,
    int? sortOrder,
  }) => SearchProvider(
    id: id ?? this.id,
    key: key ?? this.key,
    displayName: displayName ?? this.displayName,
    enabled: enabled ?? this.enabled,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SearchProvider copyWithCompanion(SearchProvidersCompanion data) {
    return SearchProvider(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SearchProvider(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('displayName: $displayName, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, displayName, enabled, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SearchProvider &&
          other.id == this.id &&
          other.key == this.key &&
          other.displayName == this.displayName &&
          other.enabled == this.enabled &&
          other.sortOrder == this.sortOrder);
}

class SearchProvidersCompanion extends UpdateCompanion<SearchProvider> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> displayName;
  final Value<bool> enabled;
  final Value<int> sortOrder;
  const SearchProvidersCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.displayName = const Value.absent(),
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  });
  SearchProvidersCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String displayName,
    this.enabled = const Value.absent(),
    this.sortOrder = const Value.absent(),
  }) : key = Value(key),
       displayName = Value(displayName);
  static Insertable<SearchProvider> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? displayName,
    Expression<bool>? enabled,
    Expression<int>? sortOrder,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (displayName != null) 'display_name': displayName,
      if (enabled != null) 'enabled': enabled,
      if (sortOrder != null) 'sort_order': sortOrder,
    });
  }

  SearchProvidersCompanion copyWith({
    Value<int>? id,
    Value<String>? key,
    Value<String>? displayName,
    Value<bool>? enabled,
    Value<int>? sortOrder,
  }) {
    return SearchProvidersCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      displayName: displayName ?? this.displayName,
      enabled: enabled ?? this.enabled,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SearchProvidersCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('displayName: $displayName, ')
          ..write('enabled: $enabled, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      ),
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String key;
  final String? value;
  const Setting({required this.key, this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    if (!nullToAbsent || value != null) {
      map['value'] = Variable<String>(value);
    }
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: Value(key),
      value: value == null && nullToAbsent
          ? const Value.absent()
          : Value(value),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String?>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String?>(value),
    };
  }

  Setting copyWith({
    String? key,
    Value<String?> value = const Value.absent(),
  }) => Setting(
    key: key ?? this.key,
    value: value.present ? value.value : this.value,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> key;
  final Value<String?> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String?>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SnapshotJobsTable extends SnapshotJobs
    with TableInfo<$SnapshotJobsTable, SnapshotJob> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SnapshotJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _websiteIdMeta = const VerificationMeta(
    'websiteId',
  );
  @override
  late final GeneratedColumn<int> websiteId = GeneratedColumn<int>(
    'website_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES websites (id)',
    ),
  );
  static const VerificationMeta _requestedAtMeta = const VerificationMeta(
    'requestedAt',
  );
  @override
  late final GeneratedColumn<DateTime> requestedAt = GeneratedColumn<DateTime>(
    'requested_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  static const VerificationMeta _resultTimestampMeta = const VerificationMeta(
    'resultTimestamp',
  );
  @override
  late final GeneratedColumn<String> resultTimestamp = GeneratedColumn<String>(
    'result_timestamp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _errorMeta = const VerificationMeta('error');
  @override
  late final GeneratedColumn<String> error = GeneratedColumn<String>(
    'error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    websiteId,
    requestedAt,
    state,
    resultTimestamp,
    error,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'snapshot_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<SnapshotJob> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('website_id')) {
      context.handle(
        _websiteIdMeta,
        websiteId.isAcceptableOrUnknown(data['website_id']!, _websiteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_websiteIdMeta);
    }
    if (data.containsKey('requested_at')) {
      context.handle(
        _requestedAtMeta,
        requestedAt.isAcceptableOrUnknown(
          data['requested_at']!,
          _requestedAtMeta,
        ),
      );
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    }
    if (data.containsKey('result_timestamp')) {
      context.handle(
        _resultTimestampMeta,
        resultTimestamp.isAcceptableOrUnknown(
          data['result_timestamp']!,
          _resultTimestampMeta,
        ),
      );
    }
    if (data.containsKey('error')) {
      context.handle(
        _errorMeta,
        error.isAcceptableOrUnknown(data['error']!, _errorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SnapshotJob map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SnapshotJob(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      websiteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}website_id'],
      )!,
      requestedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}requested_at'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}state'],
      )!,
      resultTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}result_timestamp'],
      ),
      error: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}error'],
      ),
    );
  }

  @override
  $SnapshotJobsTable createAlias(String alias) {
    return $SnapshotJobsTable(attachedDatabase, alias);
  }
}

class SnapshotJob extends DataClass implements Insertable<SnapshotJob> {
  final int id;
  final int websiteId;
  final DateTime requestedAt;
  final String state;
  final String? resultTimestamp;
  final String? error;
  const SnapshotJob({
    required this.id,
    required this.websiteId,
    required this.requestedAt,
    required this.state,
    this.resultTimestamp,
    this.error,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['website_id'] = Variable<int>(websiteId);
    map['requested_at'] = Variable<DateTime>(requestedAt);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || resultTimestamp != null) {
      map['result_timestamp'] = Variable<String>(resultTimestamp);
    }
    if (!nullToAbsent || error != null) {
      map['error'] = Variable<String>(error);
    }
    return map;
  }

  SnapshotJobsCompanion toCompanion(bool nullToAbsent) {
    return SnapshotJobsCompanion(
      id: Value(id),
      websiteId: Value(websiteId),
      requestedAt: Value(requestedAt),
      state: Value(state),
      resultTimestamp: resultTimestamp == null && nullToAbsent
          ? const Value.absent()
          : Value(resultTimestamp),
      error: error == null && nullToAbsent
          ? const Value.absent()
          : Value(error),
    );
  }

  factory SnapshotJob.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SnapshotJob(
      id: serializer.fromJson<int>(json['id']),
      websiteId: serializer.fromJson<int>(json['websiteId']),
      requestedAt: serializer.fromJson<DateTime>(json['requestedAt']),
      state: serializer.fromJson<String>(json['state']),
      resultTimestamp: serializer.fromJson<String?>(json['resultTimestamp']),
      error: serializer.fromJson<String?>(json['error']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'websiteId': serializer.toJson<int>(websiteId),
      'requestedAt': serializer.toJson<DateTime>(requestedAt),
      'state': serializer.toJson<String>(state),
      'resultTimestamp': serializer.toJson<String?>(resultTimestamp),
      'error': serializer.toJson<String?>(error),
    };
  }

  SnapshotJob copyWith({
    int? id,
    int? websiteId,
    DateTime? requestedAt,
    String? state,
    Value<String?> resultTimestamp = const Value.absent(),
    Value<String?> error = const Value.absent(),
  }) => SnapshotJob(
    id: id ?? this.id,
    websiteId: websiteId ?? this.websiteId,
    requestedAt: requestedAt ?? this.requestedAt,
    state: state ?? this.state,
    resultTimestamp: resultTimestamp.present
        ? resultTimestamp.value
        : this.resultTimestamp,
    error: error.present ? error.value : this.error,
  );
  SnapshotJob copyWithCompanion(SnapshotJobsCompanion data) {
    return SnapshotJob(
      id: data.id.present ? data.id.value : this.id,
      websiteId: data.websiteId.present ? data.websiteId.value : this.websiteId,
      requestedAt: data.requestedAt.present
          ? data.requestedAt.value
          : this.requestedAt,
      state: data.state.present ? data.state.value : this.state,
      resultTimestamp: data.resultTimestamp.present
          ? data.resultTimestamp.value
          : this.resultTimestamp,
      error: data.error.present ? data.error.value : this.error,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotJob(')
          ..write('id: $id, ')
          ..write('websiteId: $websiteId, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('state: $state, ')
          ..write('resultTimestamp: $resultTimestamp, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, websiteId, requestedAt, state, resultTimestamp, error);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SnapshotJob &&
          other.id == this.id &&
          other.websiteId == this.websiteId &&
          other.requestedAt == this.requestedAt &&
          other.state == this.state &&
          other.resultTimestamp == this.resultTimestamp &&
          other.error == this.error);
}

class SnapshotJobsCompanion extends UpdateCompanion<SnapshotJob> {
  final Value<int> id;
  final Value<int> websiteId;
  final Value<DateTime> requestedAt;
  final Value<String> state;
  final Value<String?> resultTimestamp;
  final Value<String?> error;
  const SnapshotJobsCompanion({
    this.id = const Value.absent(),
    this.websiteId = const Value.absent(),
    this.requestedAt = const Value.absent(),
    this.state = const Value.absent(),
    this.resultTimestamp = const Value.absent(),
    this.error = const Value.absent(),
  });
  SnapshotJobsCompanion.insert({
    this.id = const Value.absent(),
    required int websiteId,
    this.requestedAt = const Value.absent(),
    this.state = const Value.absent(),
    this.resultTimestamp = const Value.absent(),
    this.error = const Value.absent(),
  }) : websiteId = Value(websiteId);
  static Insertable<SnapshotJob> custom({
    Expression<int>? id,
    Expression<int>? websiteId,
    Expression<DateTime>? requestedAt,
    Expression<String>? state,
    Expression<String>? resultTimestamp,
    Expression<String>? error,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (websiteId != null) 'website_id': websiteId,
      if (requestedAt != null) 'requested_at': requestedAt,
      if (state != null) 'state': state,
      if (resultTimestamp != null) 'result_timestamp': resultTimestamp,
      if (error != null) 'error': error,
    });
  }

  SnapshotJobsCompanion copyWith({
    Value<int>? id,
    Value<int>? websiteId,
    Value<DateTime>? requestedAt,
    Value<String>? state,
    Value<String?>? resultTimestamp,
    Value<String?>? error,
  }) {
    return SnapshotJobsCompanion(
      id: id ?? this.id,
      websiteId: websiteId ?? this.websiteId,
      requestedAt: requestedAt ?? this.requestedAt,
      state: state ?? this.state,
      resultTimestamp: resultTimestamp ?? this.resultTimestamp,
      error: error ?? this.error,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (websiteId.present) {
      map['website_id'] = Variable<int>(websiteId.value);
    }
    if (requestedAt.present) {
      map['requested_at'] = Variable<DateTime>(requestedAt.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (resultTimestamp.present) {
      map['result_timestamp'] = Variable<String>(resultTimestamp.value);
    }
    if (error.present) {
      map['error'] = Variable<String>(error.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SnapshotJobsCompanion(')
          ..write('id: $id, ')
          ..write('websiteId: $websiteId, ')
          ..write('requestedAt: $requestedAt, ')
          ..write('state: $state, ')
          ..write('resultTimestamp: $resultTimestamp, ')
          ..write('error: $error')
          ..write(')'))
        .toString();
  }
}

class $CdxCacheTable extends CdxCache
    with TableInfo<$CdxCacheTable, CdxCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CdxCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _websiteIdMeta = const VerificationMeta(
    'websiteId',
  );
  @override
  late final GeneratedColumn<int> websiteId = GeneratedColumn<int>(
    'website_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _granularityMeta = const VerificationMeta(
    'granularity',
  );
  @override
  late final GeneratedColumn<String> granularity = GeneratedColumn<String>(
    'granularity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodMeta = const VerificationMeta('period');
  @override
  late final GeneratedColumn<String> period = GeneratedColumn<String>(
    'period',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _fetchedAtMeta = const VerificationMeta(
    'fetchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> fetchedAt = GeneratedColumn<DateTime>(
    'fetched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    websiteId,
    granularity,
    period,
    count,
    fetchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cdx_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<CdxCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('website_id')) {
      context.handle(
        _websiteIdMeta,
        websiteId.isAcceptableOrUnknown(data['website_id']!, _websiteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_websiteIdMeta);
    }
    if (data.containsKey('granularity')) {
      context.handle(
        _granularityMeta,
        granularity.isAcceptableOrUnknown(
          data['granularity']!,
          _granularityMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_granularityMeta);
    }
    if (data.containsKey('period')) {
      context.handle(
        _periodMeta,
        period.isAcceptableOrUnknown(data['period']!, _periodMeta),
      );
    } else if (isInserting) {
      context.missing(_periodMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    if (data.containsKey('fetched_at')) {
      context.handle(
        _fetchedAtMeta,
        fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {websiteId, granularity, period},
  ];
  @override
  CdxCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CdxCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      websiteId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}website_id'],
      )!,
      granularity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}granularity'],
      )!,
      period: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
      fetchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}fetched_at'],
      )!,
    );
  }

  @override
  $CdxCacheTable createAlias(String alias) {
    return $CdxCacheTable(attachedDatabase, alias);
  }
}

class CdxCacheData extends DataClass implements Insertable<CdxCacheData> {
  final int id;
  final int websiteId;
  final String granularity;
  final String period;
  final int count;
  final DateTime fetchedAt;
  const CdxCacheData({
    required this.id,
    required this.websiteId,
    required this.granularity,
    required this.period,
    required this.count,
    required this.fetchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['website_id'] = Variable<int>(websiteId);
    map['granularity'] = Variable<String>(granularity);
    map['period'] = Variable<String>(period);
    map['count'] = Variable<int>(count);
    map['fetched_at'] = Variable<DateTime>(fetchedAt);
    return map;
  }

  CdxCacheCompanion toCompanion(bool nullToAbsent) {
    return CdxCacheCompanion(
      id: Value(id),
      websiteId: Value(websiteId),
      granularity: Value(granularity),
      period: Value(period),
      count: Value(count),
      fetchedAt: Value(fetchedAt),
    );
  }

  factory CdxCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CdxCacheData(
      id: serializer.fromJson<int>(json['id']),
      websiteId: serializer.fromJson<int>(json['websiteId']),
      granularity: serializer.fromJson<String>(json['granularity']),
      period: serializer.fromJson<String>(json['period']),
      count: serializer.fromJson<int>(json['count']),
      fetchedAt: serializer.fromJson<DateTime>(json['fetchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'websiteId': serializer.toJson<int>(websiteId),
      'granularity': serializer.toJson<String>(granularity),
      'period': serializer.toJson<String>(period),
      'count': serializer.toJson<int>(count),
      'fetchedAt': serializer.toJson<DateTime>(fetchedAt),
    };
  }

  CdxCacheData copyWith({
    int? id,
    int? websiteId,
    String? granularity,
    String? period,
    int? count,
    DateTime? fetchedAt,
  }) => CdxCacheData(
    id: id ?? this.id,
    websiteId: websiteId ?? this.websiteId,
    granularity: granularity ?? this.granularity,
    period: period ?? this.period,
    count: count ?? this.count,
    fetchedAt: fetchedAt ?? this.fetchedAt,
  );
  CdxCacheData copyWithCompanion(CdxCacheCompanion data) {
    return CdxCacheData(
      id: data.id.present ? data.id.value : this.id,
      websiteId: data.websiteId.present ? data.websiteId.value : this.websiteId,
      granularity: data.granularity.present
          ? data.granularity.value
          : this.granularity,
      period: data.period.present ? data.period.value : this.period,
      count: data.count.present ? data.count.value : this.count,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CdxCacheData(')
          ..write('id: $id, ')
          ..write('websiteId: $websiteId, ')
          ..write('granularity: $granularity, ')
          ..write('period: $period, ')
          ..write('count: $count, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, websiteId, granularity, period, count, fetchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CdxCacheData &&
          other.id == this.id &&
          other.websiteId == this.websiteId &&
          other.granularity == this.granularity &&
          other.period == this.period &&
          other.count == this.count &&
          other.fetchedAt == this.fetchedAt);
}

class CdxCacheCompanion extends UpdateCompanion<CdxCacheData> {
  final Value<int> id;
  final Value<int> websiteId;
  final Value<String> granularity;
  final Value<String> period;
  final Value<int> count;
  final Value<DateTime> fetchedAt;
  const CdxCacheCompanion({
    this.id = const Value.absent(),
    this.websiteId = const Value.absent(),
    this.granularity = const Value.absent(),
    this.period = const Value.absent(),
    this.count = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  });
  CdxCacheCompanion.insert({
    this.id = const Value.absent(),
    required int websiteId,
    required String granularity,
    required String period,
    this.count = const Value.absent(),
    this.fetchedAt = const Value.absent(),
  }) : websiteId = Value(websiteId),
       granularity = Value(granularity),
       period = Value(period);
  static Insertable<CdxCacheData> custom({
    Expression<int>? id,
    Expression<int>? websiteId,
    Expression<String>? granularity,
    Expression<String>? period,
    Expression<int>? count,
    Expression<DateTime>? fetchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (websiteId != null) 'website_id': websiteId,
      if (granularity != null) 'granularity': granularity,
      if (period != null) 'period': period,
      if (count != null) 'count': count,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
    });
  }

  CdxCacheCompanion copyWith({
    Value<int>? id,
    Value<int>? websiteId,
    Value<String>? granularity,
    Value<String>? period,
    Value<int>? count,
    Value<DateTime>? fetchedAt,
  }) {
    return CdxCacheCompanion(
      id: id ?? this.id,
      websiteId: websiteId ?? this.websiteId,
      granularity: granularity ?? this.granularity,
      period: period ?? this.period,
      count: count ?? this.count,
      fetchedAt: fetchedAt ?? this.fetchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (websiteId.present) {
      map['website_id'] = Variable<int>(websiteId.value);
    }
    if (granularity.present) {
      map['granularity'] = Variable<String>(granularity.value);
    }
    if (period.present) {
      map['period'] = Variable<String>(period.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<DateTime>(fetchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CdxCacheCompanion(')
          ..write('id: $id, ')
          ..write('websiteId: $websiteId, ')
          ..write('granularity: $granularity, ')
          ..write('period: $period, ')
          ..write('count: $count, ')
          ..write('fetchedAt: $fetchedAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WebsitesTable websites = $WebsitesTable(this);
  late final $SnapshotsTable snapshots = $SnapshotsTable(this);
  late final $SearchProvidersTable searchProviders = $SearchProvidersTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  late final $SnapshotJobsTable snapshotJobs = $SnapshotJobsTable(this);
  late final $CdxCacheTable cdxCache = $CdxCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    websites,
    snapshots,
    searchProviders,
    settings,
    snapshotJobs,
    cdxCache,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'websites',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('snapshots', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WebsitesTableCreateCompanionBuilder =
    WebsitesCompanion Function({
      Value<int> id,
      required String url,
      Value<String?> title,
      Value<DateTime> firstSeenAt,
      Value<bool> starred,
      Value<DateTime?> starredAt,
    });
typedef $$WebsitesTableUpdateCompanionBuilder =
    WebsitesCompanion Function({
      Value<int> id,
      Value<String> url,
      Value<String?> title,
      Value<DateTime> firstSeenAt,
      Value<bool> starred,
      Value<DateTime?> starredAt,
    });

final class $$WebsitesTableReferences
    extends BaseReferences<_$AppDatabase, $WebsitesTable, Website> {
  $$WebsitesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SnapshotsTable, List<Snapshot>>
  _snapshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.snapshots,
    aliasName: 'websites__id__snapshots__website_id',
  );

  $$SnapshotsTableProcessedTableManager get snapshotsRefs {
    final manager = $$SnapshotsTableTableManager(
      $_db,
      $_db.snapshots,
    ).filter((f) => f.websiteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_snapshotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SnapshotJobsTable, List<SnapshotJob>>
  _snapshotJobsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.snapshotJobs,
    aliasName: 'websites__id__snapshot_jobs__website_id',
  );

  $$SnapshotJobsTableProcessedTableManager get snapshotJobsRefs {
    final manager = $$SnapshotJobsTableTableManager(
      $_db,
      $_db.snapshotJobs,
    ).filter((f) => f.websiteId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_snapshotJobsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WebsitesTableFilterComposer
    extends Composer<_$AppDatabase, $WebsitesTable> {
  $$WebsitesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get starredAt => $composableBuilder(
    column: $table.starredAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> snapshotsRefs(
    Expression<bool> Function($$SnapshotsTableFilterComposer f) f,
  ) {
    final $$SnapshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.websiteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableFilterComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> snapshotJobsRefs(
    Expression<bool> Function($$SnapshotJobsTableFilterComposer f) f,
  ) {
    final $$SnapshotJobsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snapshotJobs,
      getReferencedColumn: (t) => t.websiteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotJobsTableFilterComposer(
            $db: $db,
            $table: $db.snapshotJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WebsitesTableOrderingComposer
    extends Composer<_$AppDatabase, $WebsitesTable> {
  $$WebsitesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get starredAt => $composableBuilder(
    column: $table.starredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WebsitesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WebsitesTable> {
  $$WebsitesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get firstSeenAt => $composableBuilder(
    column: $table.firstSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get starred =>
      $composableBuilder(column: $table.starred, builder: (column) => column);

  GeneratedColumn<DateTime> get starredAt =>
      $composableBuilder(column: $table.starredAt, builder: (column) => column);

  Expression<T> snapshotsRefs<T extends Object>(
    Expression<T> Function($$SnapshotsTableAnnotationComposer a) f,
  ) {
    final $$SnapshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snapshots,
      getReferencedColumn: (t) => t.websiteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.snapshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> snapshotJobsRefs<T extends Object>(
    Expression<T> Function($$SnapshotJobsTableAnnotationComposer a) f,
  ) {
    final $$SnapshotJobsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.snapshotJobs,
      getReferencedColumn: (t) => t.websiteId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SnapshotJobsTableAnnotationComposer(
            $db: $db,
            $table: $db.snapshotJobs,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WebsitesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WebsitesTable,
          Website,
          $$WebsitesTableFilterComposer,
          $$WebsitesTableOrderingComposer,
          $$WebsitesTableAnnotationComposer,
          $$WebsitesTableCreateCompanionBuilder,
          $$WebsitesTableUpdateCompanionBuilder,
          (Website, $$WebsitesTableReferences),
          Website,
          PrefetchHooks Function({bool snapshotsRefs, bool snapshotJobsRefs})
        > {
  $$WebsitesTableTableManager(_$AppDatabase db, $WebsitesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WebsitesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WebsitesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WebsitesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<DateTime> firstSeenAt = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                Value<DateTime?> starredAt = const Value.absent(),
              }) => WebsitesCompanion(
                id: id,
                url: url,
                title: title,
                firstSeenAt: firstSeenAt,
                starred: starred,
                starredAt: starredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String url,
                Value<String?> title = const Value.absent(),
                Value<DateTime> firstSeenAt = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                Value<DateTime?> starredAt = const Value.absent(),
              }) => WebsitesCompanion.insert(
                id: id,
                url: url,
                title: title,
                firstSeenAt: firstSeenAt,
                starred: starred,
                starredAt: starredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WebsitesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({snapshotsRefs = false, snapshotJobsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (snapshotsRefs) db.snapshots,
                    if (snapshotJobsRefs) db.snapshotJobs,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (snapshotsRefs)
                        await $_getPrefetchedData<
                          Website,
                          $WebsitesTable,
                          Snapshot
                        >(
                          currentTable: table,
                          referencedTable: $$WebsitesTableReferences
                              ._snapshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WebsitesTableReferences(
                                db,
                                table,
                                p0,
                              ).snapshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.websiteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (snapshotJobsRefs)
                        await $_getPrefetchedData<
                          Website,
                          $WebsitesTable,
                          SnapshotJob
                        >(
                          currentTable: table,
                          referencedTable: $$WebsitesTableReferences
                              ._snapshotJobsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WebsitesTableReferences(
                                db,
                                table,
                                p0,
                              ).snapshotJobsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.websiteId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WebsitesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WebsitesTable,
      Website,
      $$WebsitesTableFilterComposer,
      $$WebsitesTableOrderingComposer,
      $$WebsitesTableAnnotationComposer,
      $$WebsitesTableCreateCompanionBuilder,
      $$WebsitesTableUpdateCompanionBuilder,
      (Website, $$WebsitesTableReferences),
      Website,
      PrefetchHooks Function({bool snapshotsRefs, bool snapshotJobsRefs})
    >;
typedef $$SnapshotsTableCreateCompanionBuilder =
    SnapshotsCompanion Function({
      Value<int> id,
      required int websiteId,
      required String timestamp,
      required String originalUrl,
      Value<int?> statusCode,
      Value<String?> mimeType,
      Value<bool> starred,
      Value<DateTime?> starredAt,
    });
typedef $$SnapshotsTableUpdateCompanionBuilder =
    SnapshotsCompanion Function({
      Value<int> id,
      Value<int> websiteId,
      Value<String> timestamp,
      Value<String> originalUrl,
      Value<int?> statusCode,
      Value<String?> mimeType,
      Value<bool> starred,
      Value<DateTime?> starredAt,
    });

final class $$SnapshotsTableReferences
    extends BaseReferences<_$AppDatabase, $SnapshotsTable, Snapshot> {
  $$SnapshotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WebsitesTable _websiteIdTable(_$AppDatabase db) =>
      db.websites.createAlias('snapshots__website_id__websites__id');

  $$WebsitesTableProcessedTableManager get websiteId {
    final $_column = $_itemColumn<int>('website_id')!;

    final manager = $$WebsitesTableTableManager(
      $_db,
      $_db.websites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_websiteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get originalUrl => $composableBuilder(
    column: $table.originalUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get starredAt => $composableBuilder(
    column: $table.starredAt,
    builder: (column) => ColumnFilters(column),
  );

  $$WebsitesTableFilterComposer get websiteId {
    final $$WebsitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.websiteId,
      referencedTable: $db.websites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WebsitesTableFilterComposer(
            $db: $db,
            $table: $db.websites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get originalUrl => $composableBuilder(
    column: $table.originalUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get starred => $composableBuilder(
    column: $table.starred,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get starredAt => $composableBuilder(
    column: $table.starredAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$WebsitesTableOrderingComposer get websiteId {
    final $$WebsitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.websiteId,
      referencedTable: $db.websites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WebsitesTableOrderingComposer(
            $db: $db,
            $table: $db.websites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnapshotsTable> {
  $$SnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get originalUrl => $composableBuilder(
    column: $table.originalUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get statusCode => $composableBuilder(
    column: $table.statusCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<bool> get starred =>
      $composableBuilder(column: $table.starred, builder: (column) => column);

  GeneratedColumn<DateTime> get starredAt =>
      $composableBuilder(column: $table.starredAt, builder: (column) => column);

  $$WebsitesTableAnnotationComposer get websiteId {
    final $$WebsitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.websiteId,
      referencedTable: $db.websites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WebsitesTableAnnotationComposer(
            $db: $db,
            $table: $db.websites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnapshotsTable,
          Snapshot,
          $$SnapshotsTableFilterComposer,
          $$SnapshotsTableOrderingComposer,
          $$SnapshotsTableAnnotationComposer,
          $$SnapshotsTableCreateCompanionBuilder,
          $$SnapshotsTableUpdateCompanionBuilder,
          (Snapshot, $$SnapshotsTableReferences),
          Snapshot,
          PrefetchHooks Function({bool websiteId})
        > {
  $$SnapshotsTableTableManager(_$AppDatabase db, $SnapshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> websiteId = const Value.absent(),
                Value<String> timestamp = const Value.absent(),
                Value<String> originalUrl = const Value.absent(),
                Value<int?> statusCode = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                Value<DateTime?> starredAt = const Value.absent(),
              }) => SnapshotsCompanion(
                id: id,
                websiteId: websiteId,
                timestamp: timestamp,
                originalUrl: originalUrl,
                statusCode: statusCode,
                mimeType: mimeType,
                starred: starred,
                starredAt: starredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int websiteId,
                required String timestamp,
                required String originalUrl,
                Value<int?> statusCode = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<bool> starred = const Value.absent(),
                Value<DateTime?> starredAt = const Value.absent(),
              }) => SnapshotsCompanion.insert(
                id: id,
                websiteId: websiteId,
                timestamp: timestamp,
                originalUrl: originalUrl,
                statusCode: statusCode,
                mimeType: mimeType,
                starred: starred,
                starredAt: starredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SnapshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({websiteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (websiteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.websiteId,
                                referencedTable: $$SnapshotsTableReferences
                                    ._websiteIdTable(db),
                                referencedColumn: $$SnapshotsTableReferences
                                    ._websiteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnapshotsTable,
      Snapshot,
      $$SnapshotsTableFilterComposer,
      $$SnapshotsTableOrderingComposer,
      $$SnapshotsTableAnnotationComposer,
      $$SnapshotsTableCreateCompanionBuilder,
      $$SnapshotsTableUpdateCompanionBuilder,
      (Snapshot, $$SnapshotsTableReferences),
      Snapshot,
      PrefetchHooks Function({bool websiteId})
    >;
typedef $$SearchProvidersTableCreateCompanionBuilder =
    SearchProvidersCompanion Function({
      Value<int> id,
      required String key,
      required String displayName,
      Value<bool> enabled,
      Value<int> sortOrder,
    });
typedef $$SearchProvidersTableUpdateCompanionBuilder =
    SearchProvidersCompanion Function({
      Value<int> id,
      Value<String> key,
      Value<String> displayName,
      Value<bool> enabled,
      Value<int> sortOrder,
    });

class $$SearchProvidersTableFilterComposer
    extends Composer<_$AppDatabase, $SearchProvidersTable> {
  $$SearchProvidersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SearchProvidersTableOrderingComposer
    extends Composer<_$AppDatabase, $SearchProvidersTable> {
  $$SearchProvidersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SearchProvidersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SearchProvidersTable> {
  $$SearchProvidersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$SearchProvidersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SearchProvidersTable,
          SearchProvider,
          $$SearchProvidersTableFilterComposer,
          $$SearchProvidersTableOrderingComposer,
          $$SearchProvidersTableAnnotationComposer,
          $$SearchProvidersTableCreateCompanionBuilder,
          $$SearchProvidersTableUpdateCompanionBuilder,
          (
            SearchProvider,
            BaseReferences<
              _$AppDatabase,
              $SearchProvidersTable,
              SearchProvider
            >,
          ),
          SearchProvider,
          PrefetchHooks Function()
        > {
  $$SearchProvidersTableTableManager(
    _$AppDatabase db,
    $SearchProvidersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SearchProvidersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SearchProvidersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SearchProvidersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SearchProvidersCompanion(
                id: id,
                key: key,
                displayName: displayName,
                enabled: enabled,
                sortOrder: sortOrder,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String key,
                required String displayName,
                Value<bool> enabled = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
              }) => SearchProvidersCompanion.insert(
                id: id,
                key: key,
                displayName: displayName,
                enabled: enabled,
                sortOrder: sortOrder,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SearchProvidersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SearchProvidersTable,
      SearchProvider,
      $$SearchProvidersTableFilterComposer,
      $$SearchProvidersTableOrderingComposer,
      $$SearchProvidersTableAnnotationComposer,
      $$SearchProvidersTableCreateCompanionBuilder,
      $$SearchProvidersTableUpdateCompanionBuilder,
      (
        SearchProvider,
        BaseReferences<_$AppDatabase, $SearchProvidersTable, SearchProvider>,
      ),
      SearchProvider,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      Value<String?> value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String?> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                Value<String?> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$SnapshotJobsTableCreateCompanionBuilder =
    SnapshotJobsCompanion Function({
      Value<int> id,
      required int websiteId,
      Value<DateTime> requestedAt,
      Value<String> state,
      Value<String?> resultTimestamp,
      Value<String?> error,
    });
typedef $$SnapshotJobsTableUpdateCompanionBuilder =
    SnapshotJobsCompanion Function({
      Value<int> id,
      Value<int> websiteId,
      Value<DateTime> requestedAt,
      Value<String> state,
      Value<String?> resultTimestamp,
      Value<String?> error,
    });

final class $$SnapshotJobsTableReferences
    extends BaseReferences<_$AppDatabase, $SnapshotJobsTable, SnapshotJob> {
  $$SnapshotJobsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WebsitesTable _websiteIdTable(_$AppDatabase db) =>
      db.websites.createAlias('snapshot_jobs__website_id__websites__id');

  $$WebsitesTableProcessedTableManager get websiteId {
    final $_column = $_itemColumn<int>('website_id')!;

    final manager = $$WebsitesTableTableManager(
      $_db,
      $_db.websites,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_websiteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SnapshotJobsTableFilterComposer
    extends Composer<_$AppDatabase, $SnapshotJobsTable> {
  $$SnapshotJobsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get resultTimestamp => $composableBuilder(
    column: $table.resultTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnFilters(column),
  );

  $$WebsitesTableFilterComposer get websiteId {
    final $$WebsitesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.websiteId,
      referencedTable: $db.websites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WebsitesTableFilterComposer(
            $db: $db,
            $table: $db.websites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $SnapshotJobsTable> {
  $$SnapshotJobsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get resultTimestamp => $composableBuilder(
    column: $table.resultTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get error => $composableBuilder(
    column: $table.error,
    builder: (column) => ColumnOrderings(column),
  );

  $$WebsitesTableOrderingComposer get websiteId {
    final $$WebsitesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.websiteId,
      referencedTable: $db.websites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WebsitesTableOrderingComposer(
            $db: $db,
            $table: $db.websites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SnapshotJobsTable> {
  $$SnapshotJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get requestedAt => $composableBuilder(
    column: $table.requestedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<String> get resultTimestamp => $composableBuilder(
    column: $table.resultTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<String> get error =>
      $composableBuilder(column: $table.error, builder: (column) => column);

  $$WebsitesTableAnnotationComposer get websiteId {
    final $$WebsitesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.websiteId,
      referencedTable: $db.websites,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WebsitesTableAnnotationComposer(
            $db: $db,
            $table: $db.websites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SnapshotJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SnapshotJobsTable,
          SnapshotJob,
          $$SnapshotJobsTableFilterComposer,
          $$SnapshotJobsTableOrderingComposer,
          $$SnapshotJobsTableAnnotationComposer,
          $$SnapshotJobsTableCreateCompanionBuilder,
          $$SnapshotJobsTableUpdateCompanionBuilder,
          (SnapshotJob, $$SnapshotJobsTableReferences),
          SnapshotJob,
          PrefetchHooks Function({bool websiteId})
        > {
  $$SnapshotJobsTableTableManager(_$AppDatabase db, $SnapshotJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SnapshotJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SnapshotJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SnapshotJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> websiteId = const Value.absent(),
                Value<DateTime> requestedAt = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> resultTimestamp = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => SnapshotJobsCompanion(
                id: id,
                websiteId: websiteId,
                requestedAt: requestedAt,
                state: state,
                resultTimestamp: resultTimestamp,
                error: error,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int websiteId,
                Value<DateTime> requestedAt = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<String?> resultTimestamp = const Value.absent(),
                Value<String?> error = const Value.absent(),
              }) => SnapshotJobsCompanion.insert(
                id: id,
                websiteId: websiteId,
                requestedAt: requestedAt,
                state: state,
                resultTimestamp: resultTimestamp,
                error: error,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SnapshotJobsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({websiteId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (websiteId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.websiteId,
                                referencedTable: $$SnapshotJobsTableReferences
                                    ._websiteIdTable(db),
                                referencedColumn: $$SnapshotJobsTableReferences
                                    ._websiteIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SnapshotJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SnapshotJobsTable,
      SnapshotJob,
      $$SnapshotJobsTableFilterComposer,
      $$SnapshotJobsTableOrderingComposer,
      $$SnapshotJobsTableAnnotationComposer,
      $$SnapshotJobsTableCreateCompanionBuilder,
      $$SnapshotJobsTableUpdateCompanionBuilder,
      (SnapshotJob, $$SnapshotJobsTableReferences),
      SnapshotJob,
      PrefetchHooks Function({bool websiteId})
    >;
typedef $$CdxCacheTableCreateCompanionBuilder =
    CdxCacheCompanion Function({
      Value<int> id,
      required int websiteId,
      required String granularity,
      required String period,
      Value<int> count,
      Value<DateTime> fetchedAt,
    });
typedef $$CdxCacheTableUpdateCompanionBuilder =
    CdxCacheCompanion Function({
      Value<int> id,
      Value<int> websiteId,
      Value<String> granularity,
      Value<String> period,
      Value<int> count,
      Value<DateTime> fetchedAt,
    });

class $$CdxCacheTableFilterComposer
    extends Composer<_$AppDatabase, $CdxCacheTable> {
  $$CdxCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get websiteId => $composableBuilder(
    column: $table.websiteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CdxCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $CdxCacheTable> {
  $$CdxCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get websiteId => $composableBuilder(
    column: $table.websiteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get period => $composableBuilder(
    column: $table.period,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get fetchedAt => $composableBuilder(
    column: $table.fetchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CdxCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $CdxCacheTable> {
  $$CdxCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get websiteId =>
      $composableBuilder(column: $table.websiteId, builder: (column) => column);

  GeneratedColumn<String> get granularity => $composableBuilder(
    column: $table.granularity,
    builder: (column) => column,
  );

  GeneratedColumn<String> get period =>
      $composableBuilder(column: $table.period, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  GeneratedColumn<DateTime> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);
}

class $$CdxCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CdxCacheTable,
          CdxCacheData,
          $$CdxCacheTableFilterComposer,
          $$CdxCacheTableOrderingComposer,
          $$CdxCacheTableAnnotationComposer,
          $$CdxCacheTableCreateCompanionBuilder,
          $$CdxCacheTableUpdateCompanionBuilder,
          (
            CdxCacheData,
            BaseReferences<_$AppDatabase, $CdxCacheTable, CdxCacheData>,
          ),
          CdxCacheData,
          PrefetchHooks Function()
        > {
  $$CdxCacheTableTableManager(_$AppDatabase db, $CdxCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CdxCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CdxCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CdxCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> websiteId = const Value.absent(),
                Value<String> granularity = const Value.absent(),
                Value<String> period = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CdxCacheCompanion(
                id: id,
                websiteId: websiteId,
                granularity: granularity,
                period: period,
                count: count,
                fetchedAt: fetchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int websiteId,
                required String granularity,
                required String period,
                Value<int> count = const Value.absent(),
                Value<DateTime> fetchedAt = const Value.absent(),
              }) => CdxCacheCompanion.insert(
                id: id,
                websiteId: websiteId,
                granularity: granularity,
                period: period,
                count: count,
                fetchedAt: fetchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CdxCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CdxCacheTable,
      CdxCacheData,
      $$CdxCacheTableFilterComposer,
      $$CdxCacheTableOrderingComposer,
      $$CdxCacheTableAnnotationComposer,
      $$CdxCacheTableCreateCompanionBuilder,
      $$CdxCacheTableUpdateCompanionBuilder,
      (
        CdxCacheData,
        BaseReferences<_$AppDatabase, $CdxCacheTable, CdxCacheData>,
      ),
      CdxCacheData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WebsitesTableTableManager get websites =>
      $$WebsitesTableTableManager(_db, _db.websites);
  $$SnapshotsTableTableManager get snapshots =>
      $$SnapshotsTableTableManager(_db, _db.snapshots);
  $$SearchProvidersTableTableManager get searchProviders =>
      $$SearchProvidersTableTableManager(_db, _db.searchProviders);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$SnapshotJobsTableTableManager get snapshotJobs =>
      $$SnapshotJobsTableTableManager(_db, _db.snapshotJobs);
  $$CdxCacheTableTableManager get cdxCache =>
      $$CdxCacheTableTableManager(_db, _db.cdxCache);
}
