// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// MigrationGenerator
// **************************************************************************

class BubbleMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('bubbles', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('type');
      table.integer('user_id');
      table.varChar('name');
      table.varChar('description');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('bubbles', cascade: true);
  }
}

class BubbleAggregationRuleMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('bubble_aggregation_rules', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('bubble_id');
      table.integer('target_bubble_id');
      table.integer('target_user_id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('bubble_aggregation_rules');
  }
}

class PostMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('posts', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('type');
      table
          .declare('posted_by', ColumnType('serial'))
          .references('users', 'id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('posts');
  }
}

class PostShareMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('post_shares', (table) {
      table.integer('bubble_id');
      table
          .declare('shared_by', ColumnType('serial'))
          .references('users', 'id');
      table.declare('post_id', ColumnType('serial')).references('posts', 'id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('post_shares');
  }
}

class SubscriptionMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('subscriptions', (table) {
      table.integer('permission');
      table
          .declare('bubble_id', ColumnType('serial'))
          .references('bubbles', 'id');
      table.declare('user_id', ColumnType('serial')).references('users', 'id');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('subscriptions');
  }
}

class UserMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('users', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('name');
      table.varChar('email');
      table.varChar('salt');
      table.varChar('hashed_password');
      table.boolean('is_email_confirmed')..defaultsTo(false);
      table.boolean('is_avatar_verified')..defaultsTo(false);
    });
  }

  @override
  down(Schema schema) {
    schema.drop('users', cascade: true);
  }
}

class UploadMigration extends Migration {
  @override
  up(Schema schema) {
    schema.create('uploads', (table) {
      table.serial('id')..primaryKey();
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.varChar('path');
      table.varChar('mime_type');
      table.integer('user_id');
      table.integer('size_in_bytes');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('uploads');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class BubbleQuery extends Query<Bubble, BubbleQueryWhere> {
  BubbleQuery({Query parent, Set<String> trampoline}) : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = BubbleQueryWhere(this);
    leftJoin(_shares = PostShareQuery(trampoline: trampoline, parent: this),
        'id', 'bubble_id',
        additionalFields: const ['bubble_id', 'shared_by', 'post_id'],
        trampoline: trampoline);
    leftJoin(
        _aggregationRules =
            BubbleAggregationRuleQuery(trampoline: trampoline, parent: this),
        'id',
        'bubble_id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'bubble_id',
          'target_bubble_id',
          'target_user_id'
        ],
        trampoline: trampoline);
  }

  @override
  final BubbleQueryValues values = BubbleQueryValues();

  BubbleQueryWhere _where;

  PostShareQuery _shares;

  BubbleAggregationRuleQuery _aggregationRules;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'bubbles';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'type',
      'user_id',
      'name',
      'description'
    ];
  }

  @override
  BubbleQueryWhere get where {
    return _where;
  }

  @override
  BubbleQueryWhere newWhereClause() {
    return BubbleQueryWhere(this);
  }

  static Bubble parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = Bubble(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        type: row[3] == null ? null : BubbleType.values[(row[3] as int)],
        userId: (row[4] as int),
        name: (row[5] as String),
        description: (row[6] as String));
    if (row.length > 7) {
      model = model.copyWith(
          shares: [PostShareQuery.parseRow(row.skip(7).take(3).toList())]
              .where((x) => x != null)
              .toList());
    }
    if (row.length > 10) {
      model = model.copyWith(
          aggregationRules: [
        BubbleAggregationRuleQuery.parseRow(row.skip(10).take(6).toList())
      ].where((x) => x != null).toList());
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  PostShareQuery get shares {
    return _shares;
  }

  BubbleAggregationRuleQuery get aggregationRules {
    return _aggregationRules;
  }

  @override
  get(QueryExecutor executor) {
    return super.get(executor).then((result) {
      return result.fold<List<Bubble>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                shares: List<_PostShare>.from(l.shares ?? [])
                  ..addAll(model.shares ?? []),
                aggregationRules:
                    List<_BubbleAggregationRule>.from(l.aggregationRules ?? [])
                      ..addAll(model.aggregationRules ?? []));
        }
      });
    });
  }

  @override
  update(QueryExecutor executor) {
    return super.update(executor).then((result) {
      return result.fold<List<Bubble>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                shares: List<_PostShare>.from(l.shares ?? [])
                  ..addAll(model.shares ?? []),
                aggregationRules:
                    List<_BubbleAggregationRule>.from(l.aggregationRules ?? [])
                      ..addAll(model.aggregationRules ?? []));
        }
      });
    });
  }

  @override
  delete(QueryExecutor executor) {
    return super.delete(executor).then((result) {
      return result.fold<List<Bubble>>([], (out, model) {
        var idx = out.indexWhere((m) => m.id == model.id);

        if (idx == -1) {
          return out..add(model);
        } else {
          var l = out[idx];
          return out
            ..[idx] = l.copyWith(
                shares: List<_PostShare>.from(l.shares ?? [])
                  ..addAll(model.shares ?? []),
                aggregationRules:
                    List<_BubbleAggregationRule>.from(l.aggregationRules ?? [])
                      ..addAll(model.aggregationRules ?? []));
        }
      });
    });
  }
}

class BubbleQueryWhere extends QueryWhere {
  BubbleQueryWhere(BubbleQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        type =
            EnumSqlExpressionBuilder<BubbleType>(query, 'type', (v) => v.index),
        userId = NumericSqlExpressionBuilder<int>(query, 'user_id'),
        name = StringSqlExpressionBuilder(query, 'name'),
        description = StringSqlExpressionBuilder(query, 'description');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final EnumSqlExpressionBuilder<BubbleType> type;

  final NumericSqlExpressionBuilder<int> userId;

  final StringSqlExpressionBuilder name;

  final StringSqlExpressionBuilder description;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, type, userId, name, description];
  }
}

class BubbleQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  BubbleType get type {
    return BubbleType.values[(values['type'] as int)];
  }

  set type(BubbleType value) => values['type'] = value?.index;
  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  String get description {
    return (values['description'] as String);
  }

  set description(String value) => values['description'] = value;
  void copyFrom(Bubble model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    type = model.type;
    userId = model.userId;
    name = model.name;
    description = model.description;
  }
}

class BubbleAggregationRuleQuery
    extends Query<BubbleAggregationRule, BubbleAggregationRuleQueryWhere> {
  BubbleAggregationRuleQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = BubbleAggregationRuleQueryWhere(this);
  }

  @override
  final BubbleAggregationRuleQueryValues values =
      BubbleAggregationRuleQueryValues();

  BubbleAggregationRuleQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'bubble_aggregation_rules';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'bubble_id',
      'target_bubble_id',
      'target_user_id'
    ];
  }

  @override
  BubbleAggregationRuleQueryWhere get where {
    return _where;
  }

  @override
  BubbleAggregationRuleQueryWhere newWhereClause() {
    return BubbleAggregationRuleQueryWhere(this);
  }

  static BubbleAggregationRule parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = BubbleAggregationRule(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        bubbleId: (row[3] as int),
        targetBubbleId: (row[4] as int),
        targetUserId: (row[5] as int));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class BubbleAggregationRuleQueryWhere extends QueryWhere {
  BubbleAggregationRuleQueryWhere(BubbleAggregationRuleQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        bubbleId = NumericSqlExpressionBuilder<int>(query, 'bubble_id'),
        targetBubbleId =
            NumericSqlExpressionBuilder<int>(query, 'target_bubble_id'),
        targetUserId =
            NumericSqlExpressionBuilder<int>(query, 'target_user_id');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final NumericSqlExpressionBuilder<int> bubbleId;

  final NumericSqlExpressionBuilder<int> targetBubbleId;

  final NumericSqlExpressionBuilder<int> targetUserId;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, bubbleId, targetBubbleId, targetUserId];
  }
}

class BubbleAggregationRuleQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  int get bubbleId {
    return (values['bubble_id'] as int);
  }

  set bubbleId(int value) => values['bubble_id'] = value;
  int get targetBubbleId {
    return (values['target_bubble_id'] as int);
  }

  set targetBubbleId(int value) => values['target_bubble_id'] = value;
  int get targetUserId {
    return (values['target_user_id'] as int);
  }

  set targetUserId(int value) => values['target_user_id'] = value;
  void copyFrom(BubbleAggregationRule model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    bubbleId = model.bubbleId;
    targetBubbleId = model.targetBubbleId;
    targetUserId = model.targetUserId;
  }
}

class PostQuery extends Query<Post, PostQueryWhere> {
  PostQuery({Query parent, Set<String> trampoline}) : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = PostQueryWhere(this);
    leftJoin(_user = UserQuery(trampoline: trampoline, parent: this),
        'posted_by', 'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'name',
          'email',
          'salt',
          'hashed_password',
          'is_email_confirmed',
          'is_avatar_verified'
        ],
        trampoline: trampoline);
  }

  @override
  final PostQueryValues values = PostQueryValues();

  PostQueryWhere _where;

  UserQuery _user;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'posts';
  }

  @override
  get fields {
    return const ['id', 'created_at', 'updated_at', 'type', 'posted_by'];
  }

  @override
  PostQueryWhere get where {
    return _where;
  }

  @override
  PostQueryWhere newWhereClause() {
    return PostQueryWhere(this);
  }

  static Post parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = Post(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        type: row[3] == null ? null : PostType.values[(row[3] as int)]);
    if (row.length > 5) {
      model = model.copyWith(
          user: UserQuery.parseRow(row.skip(5).take(9).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  UserQuery get user {
    return _user;
  }
}

class PostQueryWhere extends QueryWhere {
  PostQueryWhere(PostQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        type =
            EnumSqlExpressionBuilder<PostType>(query, 'type', (v) => v.index),
        postedBy = NumericSqlExpressionBuilder<int>(query, 'posted_by');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final EnumSqlExpressionBuilder<PostType> type;

  final NumericSqlExpressionBuilder<int> postedBy;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, type, postedBy];
  }
}

class PostQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  PostType get type {
    return PostType.values[(values['type'] as int)];
  }

  set type(PostType value) => values['type'] = value?.index;
  int get postedBy {
    return (values['posted_by'] as int);
  }

  set postedBy(int value) => values['posted_by'] = value;
  void copyFrom(Post model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    type = model.type;
    if (model.user != null) {
      values['posted_by'] = model.user.id;
    }
  }
}

class PostShareQuery extends Query<PostShare, PostShareQueryWhere> {
  PostShareQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = PostShareQueryWhere(this);
    leftJoin(_user = UserQuery(trampoline: trampoline, parent: this),
        'shared_by', 'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'name',
          'email',
          'salt',
          'hashed_password',
          'is_email_confirmed',
          'is_avatar_verified'
        ],
        trampoline: trampoline);
    leftJoin(_post = PostQuery(trampoline: trampoline, parent: this), 'post_id',
        'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'type',
          'posted_by'
        ],
        trampoline: trampoline);
  }

  @override
  final PostShareQueryValues values = PostShareQueryValues();

  PostShareQueryWhere _where;

  UserQuery _user;

  PostQuery _post;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'post_shares';
  }

  @override
  get fields {
    return const ['bubble_id', 'shared_by', 'post_id'];
  }

  @override
  PostShareQueryWhere get where {
    return _where;
  }

  @override
  PostShareQueryWhere newWhereClause() {
    return PostShareQueryWhere(this);
  }

  static PostShare parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = PostShare(bubbleId: (row[0] as int));
    if (row.length > 3) {
      model = model.copyWith(
          user: UserQuery.parseRow(row.skip(3).take(9).toList()));
    }
    if (row.length > 12) {
      model = model.copyWith(
          post: PostQuery.parseRow(row.skip(12).take(5).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  UserQuery get user {
    return _user;
  }

  PostQuery get post {
    return _post;
  }
}

class PostShareQueryWhere extends QueryWhere {
  PostShareQueryWhere(PostShareQuery query)
      : bubbleId = NumericSqlExpressionBuilder<int>(query, 'bubble_id'),
        sharedBy = NumericSqlExpressionBuilder<int>(query, 'shared_by'),
        postId = NumericSqlExpressionBuilder<int>(query, 'post_id');

  final NumericSqlExpressionBuilder<int> bubbleId;

  final NumericSqlExpressionBuilder<int> sharedBy;

  final NumericSqlExpressionBuilder<int> postId;

  @override
  get expressionBuilders {
    return [bubbleId, sharedBy, postId];
  }
}

class PostShareQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  int get bubbleId {
    return (values['bubble_id'] as int);
  }

  set bubbleId(int value) => values['bubble_id'] = value;
  int get sharedBy {
    return (values['shared_by'] as int);
  }

  set sharedBy(int value) => values['shared_by'] = value;
  int get postId {
    return (values['post_id'] as int);
  }

  set postId(int value) => values['post_id'] = value;
  void copyFrom(PostShare model) {
    bubbleId = model.bubbleId;
    if (model.user != null) {
      values['shared_by'] = model.user.id;
    }
    if (model.post != null) {
      values['post_id'] = model.post.id;
    }
  }
}

class SubscriptionQuery extends Query<Subscription, SubscriptionQueryWhere> {
  SubscriptionQuery({Query parent, Set<String> trampoline})
      : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = SubscriptionQueryWhere(this);
    leftJoin(_bubble = BubbleQuery(trampoline: trampoline, parent: this),
        'bubble_id', 'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'type',
          'user_id',
          'name',
          'description'
        ],
        trampoline: trampoline);
    leftJoin(_user = UserQuery(trampoline: trampoline, parent: this), 'user_id',
        'id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'name',
          'email',
          'salt',
          'hashed_password',
          'is_email_confirmed',
          'is_avatar_verified'
        ],
        trampoline: trampoline);
  }

  @override
  final SubscriptionQueryValues values = SubscriptionQueryValues();

  SubscriptionQueryWhere _where;

  BubbleQuery _bubble;

  UserQuery _user;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'subscriptions';
  }

  @override
  get fields {
    return const ['bubble_id', 'user_id', 'permission'];
  }

  @override
  SubscriptionQueryWhere get where {
    return _where;
  }

  @override
  SubscriptionQueryWhere newWhereClause() {
    return SubscriptionQueryWhere(this);
  }

  static Subscription parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = Subscription(
        permission:
            row[2] == null ? null : BubblePermission.values[(row[2] as int)]);
    if (row.length > 3) {
      model = model.copyWith(
          bubble: BubbleQuery.parseRow(row.skip(3).take(7).toList()));
    }
    if (row.length > 10) {
      model = model.copyWith(
          user: UserQuery.parseRow(row.skip(10).take(9).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  BubbleQuery get bubble {
    return _bubble;
  }

  UserQuery get user {
    return _user;
  }
}

class SubscriptionQueryWhere extends QueryWhere {
  SubscriptionQueryWhere(SubscriptionQuery query)
      : bubbleId = NumericSqlExpressionBuilder<int>(query, 'bubble_id'),
        userId = NumericSqlExpressionBuilder<int>(query, 'user_id'),
        permission = EnumSqlExpressionBuilder<BubblePermission>(
            query, 'permission', (v) => v.index);

  final NumericSqlExpressionBuilder<int> bubbleId;

  final NumericSqlExpressionBuilder<int> userId;

  final EnumSqlExpressionBuilder<BubblePermission> permission;

  @override
  get expressionBuilders {
    return [bubbleId, userId, permission];
  }
}

class SubscriptionQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  int get bubbleId {
    return (values['bubble_id'] as int);
  }

  set bubbleId(int value) => values['bubble_id'] = value;
  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;
  BubblePermission get permission {
    return BubblePermission.values[(values['permission'] as int)];
  }

  set permission(BubblePermission value) => values['permission'] = value?.index;
  void copyFrom(Subscription model) {
    permission = model.permission;
    if (model.bubble != null) {
      values['bubble_id'] = model.bubble.id;
    }
    if (model.user != null) {
      values['user_id'] = model.user.id;
    }
  }
}

class UserQuery extends Query<User, UserQueryWhere> {
  UserQuery({Query parent, Set<String> trampoline}) : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UserQueryWhere(this);
    leftJoin(_avatar = UploadQuery(trampoline: trampoline, parent: this), 'id',
        'user_id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'path',
          'mime_type',
          'user_id',
          'size_in_bytes'
        ],
        trampoline: trampoline);
    leftJoin(_profileBubble = BubbleQuery(trampoline: trampoline, parent: this),
        'id', 'user_id',
        additionalFields: const [
          'id',
          'created_at',
          'updated_at',
          'type',
          'user_id',
          'name',
          'description'
        ],
        trampoline: trampoline);
  }

  @override
  final UserQueryValues values = UserQueryValues();

  UserQueryWhere _where;

  UploadQuery _avatar;

  BubbleQuery _profileBubble;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'users';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'name',
      'email',
      'salt',
      'hashed_password',
      'is_email_confirmed',
      'is_avatar_verified'
    ];
  }

  @override
  UserQueryWhere get where {
    return _where;
  }

  @override
  UserQueryWhere newWhereClause() {
    return UserQueryWhere(this);
  }

  static User parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = User(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        name: (row[3] as String),
        email: (row[4] as String),
        salt: (row[5] as String),
        hashedPassword: (row[6] as String),
        isEmailConfirmed: (row[7] as bool),
        isAvatarVerified: (row[8] as bool));
    if (row.length > 9) {
      model = model.copyWith(
          avatar: UploadQuery.parseRow(row.skip(9).take(7).toList()));
    }
    if (row.length > 16) {
      model = model.copyWith(
          profileBubble: BubbleQuery.parseRow(row.skip(16).take(7).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }

  UploadQuery get avatar {
    return _avatar;
  }

  BubbleQuery get profileBubble {
    return _profileBubble;
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        name = StringSqlExpressionBuilder(query, 'name'),
        email = StringSqlExpressionBuilder(query, 'email'),
        salt = StringSqlExpressionBuilder(query, 'salt'),
        hashedPassword = StringSqlExpressionBuilder(query, 'hashed_password'),
        isEmailConfirmed =
            BooleanSqlExpressionBuilder(query, 'is_email_confirmed'),
        isAvatarVerified =
            BooleanSqlExpressionBuilder(query, 'is_avatar_verified');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder name;

  final StringSqlExpressionBuilder email;

  final StringSqlExpressionBuilder salt;

  final StringSqlExpressionBuilder hashedPassword;

  final BooleanSqlExpressionBuilder isEmailConfirmed;

  final BooleanSqlExpressionBuilder isAvatarVerified;

  @override
  get expressionBuilders {
    return [
      id,
      createdAt,
      updatedAt,
      name,
      email,
      salt,
      hashedPassword,
      isEmailConfirmed,
      isAvatarVerified
    ];
  }
}

class UserQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  String get email {
    return (values['email'] as String);
  }

  set email(String value) => values['email'] = value;
  String get salt {
    return (values['salt'] as String);
  }

  set salt(String value) => values['salt'] = value;
  String get hashedPassword {
    return (values['hashed_password'] as String);
  }

  set hashedPassword(String value) => values['hashed_password'] = value;
  bool get isEmailConfirmed {
    return (values['is_email_confirmed'] as bool);
  }

  set isEmailConfirmed(bool value) => values['is_email_confirmed'] = value;
  bool get isAvatarVerified {
    return (values['is_avatar_verified'] as bool);
  }

  set isAvatarVerified(bool value) => values['is_avatar_verified'] = value;
  void copyFrom(User model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    name = model.name;
    email = model.email;
    salt = model.salt;
    hashedPassword = model.hashedPassword;
    isEmailConfirmed = model.isEmailConfirmed;
    isAvatarVerified = model.isAvatarVerified;
  }
}

class UploadQuery extends Query<Upload, UploadQueryWhere> {
  UploadQuery({Query parent, Set<String> trampoline}) : super(parent: parent) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UploadQueryWhere(this);
  }

  @override
  final UploadQueryValues values = UploadQueryValues();

  UploadQueryWhere _where;

  @override
  get casts {
    return {};
  }

  @override
  get tableName {
    return 'uploads';
  }

  @override
  get fields {
    return const [
      'id',
      'created_at',
      'updated_at',
      'path',
      'mime_type',
      'user_id',
      'size_in_bytes'
    ];
  }

  @override
  UploadQueryWhere get where {
    return _where;
  }

  @override
  UploadQueryWhere newWhereClause() {
    return UploadQueryWhere(this);
  }

  static Upload parseRow(List row) {
    if (row.every((x) => x == null)) return null;
    var model = Upload(
        id: row[0].toString(),
        createdAt: (row[1] as DateTime),
        updatedAt: (row[2] as DateTime),
        path: (row[3] as String),
        mimeType: (row[4] as String),
        userId: (row[5] as int),
        sizeInBytes: (row[6] as int));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class UploadQueryWhere extends QueryWhere {
  UploadQueryWhere(UploadQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at'),
        path = StringSqlExpressionBuilder(query, 'path'),
        mimeType = StringSqlExpressionBuilder(query, 'mime_type'),
        userId = NumericSqlExpressionBuilder<int>(query, 'user_id'),
        sizeInBytes = NumericSqlExpressionBuilder<int>(query, 'size_in_bytes');

  final NumericSqlExpressionBuilder<int> id;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  final StringSqlExpressionBuilder path;

  final StringSqlExpressionBuilder mimeType;

  final NumericSqlExpressionBuilder<int> userId;

  final NumericSqlExpressionBuilder<int> sizeInBytes;

  @override
  get expressionBuilders {
    return [id, createdAt, updatedAt, path, mimeType, userId, sizeInBytes];
  }
}

class UploadQueryValues extends MapQueryValues {
  @override
  get casts {
    return {};
  }

  String get id {
    return (values['id'] as String);
  }

  set id(String value) => values['id'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  String get path {
    return (values['path'] as String);
  }

  set path(String value) => values['path'] = value;
  String get mimeType {
    return (values['mime_type'] as String);
  }

  set mimeType(String value) => values['mime_type'] = value;
  int get userId {
    return (values['user_id'] as int);
  }

  set userId(int value) => values['user_id'] = value;
  int get sizeInBytes {
    return (values['size_in_bytes'] as int);
  }

  set sizeInBytes(int value) => values['size_in_bytes'] = value;
  void copyFrom(Upload model) {
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    path = model.path;
    mimeType = model.mimeType;
    userId = model.userId;
    sizeInBytes = model.sizeInBytes;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Bubble extends _Bubble {
  Bubble(
      {this.id,
      this.createdAt,
      this.updatedAt,
      @required this.type,
      this.userId,
      @required this.name,
      @required this.description,
      List<_PostShare> shares,
      List<_BubbleAggregationRule> aggregationRules})
      : this.shares = List.unmodifiable(shares ?? []),
        this.aggregationRules = List.unmodifiable(aggregationRules ?? []);

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  BubbleType type;

  @override
  int userId;

  @override
  String name;

  @override
  String description;

  @override
  List<_PostShare> shares;

  @override
  List<_BubbleAggregationRule> aggregationRules;

  Bubble copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      BubbleType type,
      int userId,
      String name,
      String description,
      List<_PostShare> shares,
      List<_BubbleAggregationRule> aggregationRules}) {
    return Bubble(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        type: type ?? this.type,
        userId: userId ?? this.userId,
        name: name ?? this.name,
        description: description ?? this.description,
        shares: shares ?? this.shares,
        aggregationRules: aggregationRules ?? this.aggregationRules);
  }

  bool operator ==(other) {
    return other is _Bubble &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.type == type &&
        other.userId == userId &&
        other.name == name &&
        other.description == description &&
        ListEquality<_PostShare>(DefaultEquality<_PostShare>())
            .equals(other.shares, shares) &&
        ListEquality<_BubbleAggregationRule>(
                DefaultEquality<_BubbleAggregationRule>())
            .equals(other.aggregationRules, aggregationRules);
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      type,
      userId,
      name,
      description,
      shares,
      aggregationRules
    ]);
  }

  @override
  String toString() {
    return "Bubble(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, type=$type, userId=$userId, name=$name, description=$description, shares=$shares, aggregationRules=$aggregationRules)";
  }

  Map<String, dynamic> toJson() {
    return BubbleSerializer.toMap(this);
  }
}

@generatedSerializable
class BubbleAggregationRule extends _BubbleAggregationRule {
  BubbleAggregationRule(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.bubbleId,
      this.targetBubbleId,
      this.targetUserId});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  int bubbleId;

  @override
  int targetBubbleId;

  @override
  int targetUserId;

  BubbleAggregationRule copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      int bubbleId,
      int targetBubbleId,
      int targetUserId}) {
    return BubbleAggregationRule(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        bubbleId: bubbleId ?? this.bubbleId,
        targetBubbleId: targetBubbleId ?? this.targetBubbleId,
        targetUserId: targetUserId ?? this.targetUserId);
  }

  bool operator ==(other) {
    return other is _BubbleAggregationRule &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.bubbleId == bubbleId &&
        other.targetBubbleId == targetBubbleId &&
        other.targetUserId == targetUserId;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, createdAt, updatedAt, bubbleId, targetBubbleId, targetUserId]);
  }

  @override
  String toString() {
    return "BubbleAggregationRule(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, bubbleId=$bubbleId, targetBubbleId=$targetBubbleId, targetUserId=$targetUserId)";
  }

  Map<String, dynamic> toJson() {
    return BubbleAggregationRuleSerializer.toMap(this);
  }
}

@generatedSerializable
class Post extends _Post {
  Post(
      {this.id,
      this.createdAt,
      this.updatedAt,
      @required this.type,
      this.user});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  PostType type;

  @override
  _User user;

  Post copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      PostType type,
      _User user}) {
    return Post(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        type: type ?? this.type,
        user: user ?? this.user);
  }

  bool operator ==(other) {
    return other is _Post &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.type == type &&
        other.user == user;
  }

  @override
  int get hashCode {
    return hashObjects([id, createdAt, updatedAt, type, user]);
  }

  @override
  String toString() {
    return "Post(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, type=$type, user=$user)";
  }

  Map<String, dynamic> toJson() {
    return PostSerializer.toMap(this);
  }
}

@generatedSerializable
class PostShare extends _PostShare {
  PostShare({@required this.bubbleId, this.user, this.post});

  @override
  int bubbleId;

  @override
  _User user;

  @override
  _Post post;

  PostShare copyWith({int bubbleId, _User user, _Post post}) {
    return PostShare(
        bubbleId: bubbleId ?? this.bubbleId,
        user: user ?? this.user,
        post: post ?? this.post);
  }

  bool operator ==(other) {
    return other is _PostShare &&
        other.bubbleId == bubbleId &&
        other.user == user &&
        other.post == post;
  }

  @override
  int get hashCode {
    return hashObjects([bubbleId, user, post]);
  }

  @override
  String toString() {
    return "PostShare(bubbleId=$bubbleId, user=$user, post=$post)";
  }

  Map<String, dynamic> toJson() {
    return PostShareSerializer.toMap(this);
  }
}

@generatedSerializable
class Subscription extends _Subscription {
  Subscription({this.bubble, this.user, @required this.permission});

  @override
  _Bubble bubble;

  @override
  _User user;

  @override
  BubblePermission permission;

  Subscription copyWith(
      {_Bubble bubble, _User user, BubblePermission permission}) {
    return Subscription(
        bubble: bubble ?? this.bubble,
        user: user ?? this.user,
        permission: permission ?? this.permission);
  }

  bool operator ==(other) {
    return other is _Subscription &&
        other.bubble == bubble &&
        other.user == user &&
        other.permission == permission;
  }

  @override
  int get hashCode {
    return hashObjects([bubble, user, permission]);
  }

  @override
  String toString() {
    return "Subscription(bubble=$bubble, user=$user, permission=$permission)";
  }

  Map<String, dynamic> toJson() {
    return SubscriptionSerializer.toMap(this);
  }
}

@generatedSerializable
class User extends _User {
  User(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.email,
      this.salt,
      this.hashedPassword,
      this.isEmailConfirmed = false,
      this.isAvatarVerified = false,
      this.avatar,
      this.profileBubble});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  String name;

  @override
  String email;

  @override
  String salt;

  @override
  String hashedPassword;

  @override
  bool isEmailConfirmed;

  @override
  bool isAvatarVerified;

  @override
  _Upload avatar;

  @override
  _Bubble profileBubble;

  User copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String name,
      String email,
      String salt,
      String hashedPassword,
      bool isEmailConfirmed,
      bool isAvatarVerified,
      _Upload avatar,
      _Bubble profileBubble}) {
    return User(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        name: name ?? this.name,
        email: email ?? this.email,
        salt: salt ?? this.salt,
        hashedPassword: hashedPassword ?? this.hashedPassword,
        isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
        isAvatarVerified: isAvatarVerified ?? this.isAvatarVerified,
        avatar: avatar ?? this.avatar,
        profileBubble: profileBubble ?? this.profileBubble);
  }

  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.name == name &&
        other.email == email &&
        other.salt == salt &&
        other.hashedPassword == hashedPassword &&
        other.isEmailConfirmed == isEmailConfirmed &&
        other.isAvatarVerified == isAvatarVerified &&
        other.avatar == avatar &&
        other.profileBubble == profileBubble;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      createdAt,
      updatedAt,
      name,
      email,
      salt,
      hashedPassword,
      isEmailConfirmed,
      isAvatarVerified,
      avatar,
      profileBubble
    ]);
  }

  @override
  String toString() {
    return "User(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, name=$name, email=$email, salt=$salt, hashedPassword=$hashedPassword, isEmailConfirmed=$isEmailConfirmed, isAvatarVerified=$isAvatarVerified, avatar=$avatar, profileBubble=$profileBubble)";
  }

  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this);
  }
}

@generatedSerializable
class Upload extends _Upload {
  Upload(
      {this.id,
      this.createdAt,
      this.updatedAt,
      this.path,
      this.mimeType,
      this.userId,
      this.sizeInBytes});

  /// A unique identifier corresponding to this item.
  @override
  String id;

  /// The time at which this item was created.
  @override
  DateTime createdAt;

  /// The last time at which this item was updated.
  @override
  DateTime updatedAt;

  @override
  String path;

  @override
  String mimeType;

  @override
  int userId;

  @override
  int sizeInBytes;

  Upload copyWith(
      {String id,
      DateTime createdAt,
      DateTime updatedAt,
      String path,
      String mimeType,
      int userId,
      int sizeInBytes}) {
    return Upload(
        id: id ?? this.id,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        path: path ?? this.path,
        mimeType: mimeType ?? this.mimeType,
        userId: userId ?? this.userId,
        sizeInBytes: sizeInBytes ?? this.sizeInBytes);
  }

  bool operator ==(other) {
    return other is _Upload &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.path == path &&
        other.mimeType == mimeType &&
        other.userId == userId &&
        other.sizeInBytes == sizeInBytes;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, createdAt, updatedAt, path, mimeType, userId, sizeInBytes]);
  }

  @override
  String toString() {
    return "Upload(id=$id, createdAt=$createdAt, updatedAt=$updatedAt, path=$path, mimeType=$mimeType, userId=$userId, sizeInBytes=$sizeInBytes)";
  }

  Map<String, dynamic> toJson() {
    return UploadSerializer.toMap(this);
  }
}

@generatedSerializable
class BubbleConfig implements _BubbleConfig {
  const BubbleConfig();

  BubbleConfig copyWith() {
    return BubbleConfig();
  }

  bool operator ==(other) {
    return other is _BubbleConfig;
  }

  @override
  int get hashCode {
    return hashObjects([]);
  }

  @override
  String toString() {
    return "BubbleConfig()";
  }

  Map<String, dynamic> toJson() {
    return BubbleConfigSerializer.toMap(this);
  }
}

@generatedSerializable
class BubbleThemeConfig implements _BubbleThemeConfig {
  const BubbleThemeConfig();

  BubbleThemeConfig copyWith() {
    return BubbleThemeConfig();
  }

  bool operator ==(other) {
    return other is _BubbleThemeConfig;
  }

  @override
  int get hashCode {
    return hashObjects([]);
  }

  @override
  String toString() {
    return "BubbleThemeConfig()";
  }

  Map<String, dynamic> toJson() {
    return BubbleThemeConfigSerializer.toMap(this);
  }
}

@generatedSerializable
class LoginBody extends _LoginBody {
  LoginBody({@required this.email, @required this.password});

  @override
  String email;

  @override
  String password;

  LoginBody copyWith({String email, String password}) {
    return LoginBody(
        email: email ?? this.email, password: password ?? this.password);
  }

  bool operator ==(other) {
    return other is _LoginBody &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode {
    return hashObjects([email, password]);
  }

  @override
  String toString() {
    return "LoginBody(email=$email, password=$password)";
  }

  Map<String, dynamic> toJson() {
    return LoginBodySerializer.toMap(this);
  }
}

@generatedSerializable
class SignupBody extends _SignupBody {
  SignupBody(
      {@required this.email, @required this.password, @required this.name});

  @override
  String email;

  @override
  String password;

  @override
  String name;

  SignupBody copyWith({String email, String password, String name}) {
    return SignupBody(
        email: email ?? this.email,
        password: password ?? this.password,
        name: name ?? this.name);
  }

  bool operator ==(other) {
    return other is _SignupBody &&
        other.email == email &&
        other.password == password &&
        other.name == name;
  }

  @override
  int get hashCode {
    return hashObjects([email, password, name]);
  }

  @override
  String toString() {
    return "SignupBody(email=$email, password=$password, name=$name)";
  }

  Map<String, dynamic> toJson() {
    return SignupBodySerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const BubbleSerializer bubbleSerializer = BubbleSerializer();

class BubbleEncoder extends Converter<Bubble, Map> {
  const BubbleEncoder();

  @override
  Map convert(Bubble model) => BubbleSerializer.toMap(model);
}

class BubbleDecoder extends Converter<Map, Bubble> {
  const BubbleDecoder();

  @override
  Bubble convert(Map map) => BubbleSerializer.fromMap(map);
}

class BubbleSerializer extends Codec<Bubble, Map> {
  const BubbleSerializer();

  @override
  get encoder => const BubbleEncoder();
  @override
  get decoder => const BubbleDecoder();
  static Bubble fromMap(Map map) {
    if (map['type'] == null) {
      throw FormatException("Missing required field 'type' on Bubble.");
    }

    if (map['name'] == null) {
      throw FormatException("Missing required field 'name' on Bubble.");
    }

    if (map['description'] == null) {
      throw FormatException("Missing required field 'description' on Bubble.");
    }

    return Bubble(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        type: map['type'] is BubbleType
            ? (map['type'] as BubbleType)
            : (map['type'] is int
                ? BubbleType.values[map['type'] as int]
                : null),
        userId: map['user_id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        shares: map['shares'] is Iterable
            ? List.unmodifiable(((map['shares'] as Iterable).whereType<Map>())
                .map(PostShareSerializer.fromMap))
            : null,
        aggregationRules: map['aggregation_rules'] is Iterable
            ? List.unmodifiable(
                ((map['aggregation_rules'] as Iterable).whereType<Map>())
                    .map(BubbleAggregationRuleSerializer.fromMap))
            : null);
  }

  static Map<String, dynamic> toMap(_Bubble model) {
    if (model == null) {
      return null;
    }
    if (model.type == null) {
      throw FormatException("Missing required field 'type' on Bubble.");
    }

    if (model.name == null) {
      throw FormatException("Missing required field 'name' on Bubble.");
    }

    if (model.description == null) {
      throw FormatException("Missing required field 'description' on Bubble.");
    }

    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'type': model.type == null ? null : BubbleType.values.indexOf(model.type),
      'user_id': model.userId,
      'name': model.name,
      'description': model.description,
      'shares':
          model.shares?.map((m) => PostShareSerializer.toMap(m))?.toList(),
      'aggregation_rules': model.aggregationRules
          ?.map((m) => BubbleAggregationRuleSerializer.toMap(m))
          ?.toList()
    };
  }
}

abstract class BubbleFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    type,
    userId,
    name,
    description,
    shares,
    aggregationRules
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String type = 'type';

  static const String userId = 'user_id';

  static const String name = 'name';

  static const String description = 'description';

  static const String shares = 'shares';

  static const String aggregationRules = 'aggregation_rules';
}

const BubbleAggregationRuleSerializer bubbleAggregationRuleSerializer =
    BubbleAggregationRuleSerializer();

class BubbleAggregationRuleEncoder
    extends Converter<BubbleAggregationRule, Map> {
  const BubbleAggregationRuleEncoder();

  @override
  Map convert(BubbleAggregationRule model) =>
      BubbleAggregationRuleSerializer.toMap(model);
}

class BubbleAggregationRuleDecoder
    extends Converter<Map, BubbleAggregationRule> {
  const BubbleAggregationRuleDecoder();

  @override
  BubbleAggregationRule convert(Map map) =>
      BubbleAggregationRuleSerializer.fromMap(map);
}

class BubbleAggregationRuleSerializer
    extends Codec<BubbleAggregationRule, Map> {
  const BubbleAggregationRuleSerializer();

  @override
  get encoder => const BubbleAggregationRuleEncoder();
  @override
  get decoder => const BubbleAggregationRuleDecoder();
  static BubbleAggregationRule fromMap(Map map) {
    return BubbleAggregationRule(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        bubbleId: map['bubble_id'] as int,
        targetBubbleId: map['target_bubble_id'] as int,
        targetUserId: map['target_user_id'] as int);
  }

  static Map<String, dynamic> toMap(_BubbleAggregationRule model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'bubble_id': model.bubbleId,
      'target_bubble_id': model.targetBubbleId,
      'target_user_id': model.targetUserId
    };
  }
}

abstract class BubbleAggregationRuleFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    bubbleId,
    targetBubbleId,
    targetUserId
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String bubbleId = 'bubble_id';

  static const String targetBubbleId = 'target_bubble_id';

  static const String targetUserId = 'target_user_id';
}

const PostSerializer postSerializer = PostSerializer();

class PostEncoder extends Converter<Post, Map> {
  const PostEncoder();

  @override
  Map convert(Post model) => PostSerializer.toMap(model);
}

class PostDecoder extends Converter<Map, Post> {
  const PostDecoder();

  @override
  Post convert(Map map) => PostSerializer.fromMap(map);
}

class PostSerializer extends Codec<Post, Map> {
  const PostSerializer();

  @override
  get encoder => const PostEncoder();
  @override
  get decoder => const PostDecoder();
  static Post fromMap(Map map) {
    if (map['type'] == null) {
      throw FormatException("Missing required field 'type' on Post.");
    }

    return Post(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        type: map['type'] is PostType
            ? (map['type'] as PostType)
            : (map['type'] is int ? PostType.values[map['type'] as int] : null),
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(_Post model) {
    if (model == null) {
      return null;
    }
    if (model.type == null) {
      throw FormatException("Missing required field 'type' on Post.");
    }

    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'type': model.type == null ? null : PostType.values.indexOf(model.type),
      'user': UserSerializer.toMap(model.user)
    };
  }
}

abstract class PostFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    type,
    user
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String type = 'type';

  static const String user = 'user';
}

const PostShareSerializer postShareSerializer = PostShareSerializer();

class PostShareEncoder extends Converter<PostShare, Map> {
  const PostShareEncoder();

  @override
  Map convert(PostShare model) => PostShareSerializer.toMap(model);
}

class PostShareDecoder extends Converter<Map, PostShare> {
  const PostShareDecoder();

  @override
  PostShare convert(Map map) => PostShareSerializer.fromMap(map);
}

class PostShareSerializer extends Codec<PostShare, Map> {
  const PostShareSerializer();

  @override
  get encoder => const PostShareEncoder();
  @override
  get decoder => const PostShareDecoder();
  static PostShare fromMap(Map map) {
    if (map['bubble_id'] == null) {
      throw FormatException("Missing required field 'bubble_id' on PostShare.");
    }

    return PostShare(
        bubbleId: map['bubble_id'] as int,
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null,
        post: map['post'] != null
            ? PostSerializer.fromMap(map['post'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(_PostShare model) {
    if (model == null) {
      return null;
    }
    if (model.bubbleId == null) {
      throw FormatException("Missing required field 'bubble_id' on PostShare.");
    }

    return {
      'bubble_id': model.bubbleId,
      'user': UserSerializer.toMap(model.user),
      'post': PostSerializer.toMap(model.post)
    };
  }
}

abstract class PostShareFields {
  static const List<String> allFields = <String>[bubbleId, user, post];

  static const String bubbleId = 'bubble_id';

  static const String user = 'user';

  static const String post = 'post';
}

const SubscriptionSerializer subscriptionSerializer = SubscriptionSerializer();

class SubscriptionEncoder extends Converter<Subscription, Map> {
  const SubscriptionEncoder();

  @override
  Map convert(Subscription model) => SubscriptionSerializer.toMap(model);
}

class SubscriptionDecoder extends Converter<Map, Subscription> {
  const SubscriptionDecoder();

  @override
  Subscription convert(Map map) => SubscriptionSerializer.fromMap(map);
}

class SubscriptionSerializer extends Codec<Subscription, Map> {
  const SubscriptionSerializer();

  @override
  get encoder => const SubscriptionEncoder();
  @override
  get decoder => const SubscriptionDecoder();
  static Subscription fromMap(Map map) {
    if (map['permission'] == null) {
      throw FormatException(
          "Missing required field 'permission' on Subscription.");
    }

    return Subscription(
        bubble: map['bubble'] != null
            ? BubbleSerializer.fromMap(map['bubble'] as Map)
            : null,
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null,
        permission: map['permission'] is BubblePermission
            ? (map['permission'] as BubblePermission)
            : (map['permission'] is int
                ? BubblePermission.values[map['permission'] as int]
                : null));
  }

  static Map<String, dynamic> toMap(_Subscription model) {
    if (model == null) {
      return null;
    }
    if (model.permission == null) {
      throw FormatException(
          "Missing required field 'permission' on Subscription.");
    }

    return {
      'bubble': BubbleSerializer.toMap(model.bubble),
      'user': UserSerializer.toMap(model.user),
      'permission': model.permission == null
          ? null
          : BubblePermission.values.indexOf(model.permission)
    };
  }
}

abstract class SubscriptionFields {
  static const List<String> allFields = <String>[bubble, user, permission];

  static const String bubble = 'bubble';

  static const String user = 'user';

  static const String permission = 'permission';
}

const UserSerializer userSerializer = UserSerializer();

class UserEncoder extends Converter<User, Map> {
  const UserEncoder();

  @override
  Map convert(User model) => UserSerializer.toMap(model);
}

class UserDecoder extends Converter<Map, User> {
  const UserDecoder();

  @override
  User convert(Map map) => UserSerializer.fromMap(map);
}

class UserSerializer extends Codec<User, Map> {
  const UserSerializer();

  @override
  get encoder => const UserEncoder();
  @override
  get decoder => const UserDecoder();
  static User fromMap(Map map) {
    return User(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        name: map['name'] as String,
        email: map['email'] as String,
        salt: map['salt'] as String,
        hashedPassword: map['hashed_password'] as String,
        isEmailConfirmed: map['is_email_confirmed'] as bool ?? false,
        isAvatarVerified: map['is_avatar_verified'] as bool ?? false,
        avatar: map['avatar'] != null
            ? UploadSerializer.fromMap(map['avatar'] as Map)
            : null,
        profileBubble: map['profile_bubble'] != null
            ? BubbleSerializer.fromMap(map['profile_bubble'] as Map)
            : null);
  }

  static Map<String, dynamic> toMap(_User model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'name': model.name,
      'email': model.email,
      'is_email_confirmed': model.isEmailConfirmed,
      'is_avatar_verified': model.isAvatarVerified,
      'avatar': UploadSerializer.toMap(model.avatar),
      'profile_bubble': BubbleSerializer.toMap(model.profileBubble)
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    name,
    email,
    salt,
    hashedPassword,
    isEmailConfirmed,
    isAvatarVerified,
    avatar,
    profileBubble
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String name = 'name';

  static const String email = 'email';

  static const String salt = 'salt';

  static const String hashedPassword = 'hashed_password';

  static const String isEmailConfirmed = 'is_email_confirmed';

  static const String isAvatarVerified = 'is_avatar_verified';

  static const String avatar = 'avatar';

  static const String profileBubble = 'profile_bubble';
}

const UploadSerializer uploadSerializer = UploadSerializer();

class UploadEncoder extends Converter<Upload, Map> {
  const UploadEncoder();

  @override
  Map convert(Upload model) => UploadSerializer.toMap(model);
}

class UploadDecoder extends Converter<Map, Upload> {
  const UploadDecoder();

  @override
  Upload convert(Map map) => UploadSerializer.fromMap(map);
}

class UploadSerializer extends Codec<Upload, Map> {
  const UploadSerializer();

  @override
  get encoder => const UploadEncoder();
  @override
  get decoder => const UploadDecoder();
  static Upload fromMap(Map map) {
    return Upload(
        id: map['id'] as String,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null,
        path: map['path'] as String,
        mimeType: map['mime_type'] as String,
        userId: map['user_id'] as int,
        sizeInBytes: map['size_in_bytes'] as int);
  }

  static Map<String, dynamic> toMap(_Upload model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String(),
      'mime_type': model.mimeType,
      'user_id': model.userId,
      'size_in_bytes': model.sizeInBytes
    };
  }
}

abstract class UploadFields {
  static const List<String> allFields = <String>[
    id,
    createdAt,
    updatedAt,
    path,
    mimeType,
    userId,
    sizeInBytes
  ];

  static const String id = 'id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';

  static const String path = 'path';

  static const String mimeType = 'mime_type';

  static const String userId = 'user_id';

  static const String sizeInBytes = 'size_in_bytes';
}

const BubbleConfigSerializer bubbleConfigSerializer = BubbleConfigSerializer();

class BubbleConfigEncoder extends Converter<BubbleConfig, Map> {
  const BubbleConfigEncoder();

  @override
  Map convert(BubbleConfig model) => BubbleConfigSerializer.toMap(model);
}

class BubbleConfigDecoder extends Converter<Map, BubbleConfig> {
  const BubbleConfigDecoder();

  @override
  BubbleConfig convert(Map map) => BubbleConfigSerializer.fromMap(map);
}

class BubbleConfigSerializer extends Codec<BubbleConfig, Map> {
  const BubbleConfigSerializer();

  @override
  get encoder => const BubbleConfigEncoder();
  @override
  get decoder => const BubbleConfigDecoder();
  static BubbleConfig fromMap(Map map) {
    return BubbleConfig();
  }

  static Map<String, dynamic> toMap(_BubbleConfig model) {
    if (model == null) {
      return null;
    }
    return {};
  }
}

abstract class BubbleConfigFields {
  static const List<String> allFields = <String>[];
}

const BubbleThemeConfigSerializer bubbleThemeConfigSerializer =
    BubbleThemeConfigSerializer();

class BubbleThemeConfigEncoder extends Converter<BubbleThemeConfig, Map> {
  const BubbleThemeConfigEncoder();

  @override
  Map convert(BubbleThemeConfig model) =>
      BubbleThemeConfigSerializer.toMap(model);
}

class BubbleThemeConfigDecoder extends Converter<Map, BubbleThemeConfig> {
  const BubbleThemeConfigDecoder();

  @override
  BubbleThemeConfig convert(Map map) =>
      BubbleThemeConfigSerializer.fromMap(map);
}

class BubbleThemeConfigSerializer extends Codec<BubbleThemeConfig, Map> {
  const BubbleThemeConfigSerializer();

  @override
  get encoder => const BubbleThemeConfigEncoder();
  @override
  get decoder => const BubbleThemeConfigDecoder();
  static BubbleThemeConfig fromMap(Map map) {
    return BubbleThemeConfig();
  }

  static Map<String, dynamic> toMap(_BubbleThemeConfig model) {
    if (model == null) {
      return null;
    }
    return {};
  }
}

abstract class BubbleThemeConfigFields {
  static const List<String> allFields = <String>[];
}

const LoginBodySerializer loginBodySerializer = LoginBodySerializer();

class LoginBodyEncoder extends Converter<LoginBody, Map> {
  const LoginBodyEncoder();

  @override
  Map convert(LoginBody model) => LoginBodySerializer.toMap(model);
}

class LoginBodyDecoder extends Converter<Map, LoginBody> {
  const LoginBodyDecoder();

  @override
  LoginBody convert(Map map) => LoginBodySerializer.fromMap(map);
}

class LoginBodySerializer extends Codec<LoginBody, Map> {
  const LoginBodySerializer();

  @override
  get encoder => const LoginBodyEncoder();
  @override
  get decoder => const LoginBodyDecoder();
  static LoginBody fromMap(Map map) {
    if (map['email'] == null) {
      throw FormatException("Missing required field 'email' on LoginBody.");
    }

    if (map['password'] == null) {
      throw FormatException("Missing required field 'password' on LoginBody.");
    }

    return LoginBody(
        email: map['email'] as String, password: map['password'] as String);
  }

  static Map<String, dynamic> toMap(_LoginBody model) {
    if (model == null) {
      return null;
    }
    if (model.email == null) {
      throw FormatException("Missing required field 'email' on LoginBody.");
    }

    if (model.password == null) {
      throw FormatException("Missing required field 'password' on LoginBody.");
    }

    return {'email': model.email, 'password': model.password};
  }
}

abstract class LoginBodyFields {
  static const List<String> allFields = <String>[email, password];

  static const String email = 'email';

  static const String password = 'password';
}

const SignupBodySerializer signupBodySerializer = SignupBodySerializer();

class SignupBodyEncoder extends Converter<SignupBody, Map> {
  const SignupBodyEncoder();

  @override
  Map convert(SignupBody model) => SignupBodySerializer.toMap(model);
}

class SignupBodyDecoder extends Converter<Map, SignupBody> {
  const SignupBodyDecoder();

  @override
  SignupBody convert(Map map) => SignupBodySerializer.fromMap(map);
}

class SignupBodySerializer extends Codec<SignupBody, Map> {
  const SignupBodySerializer();

  @override
  get encoder => const SignupBodyEncoder();
  @override
  get decoder => const SignupBodyDecoder();
  static SignupBody fromMap(Map map) {
    if (map['email'] == null) {
      throw FormatException("Missing required field 'email' on SignupBody.");
    }

    if (map['password'] == null) {
      throw FormatException("Missing required field 'password' on SignupBody.");
    }

    if (map['name'] == null) {
      throw FormatException("Missing required field 'name' on SignupBody.");
    }

    return SignupBody(
        email: map['email'] as String,
        password: map['password'] as String,
        name: map['name'] as String);
  }

  static Map<String, dynamic> toMap(_SignupBody model) {
    if (model == null) {
      return null;
    }
    if (model.email == null) {
      throw FormatException("Missing required field 'email' on SignupBody.");
    }

    if (model.password == null) {
      throw FormatException("Missing required field 'password' on SignupBody.");
    }

    if (model.name == null) {
      throw FormatException("Missing required field 'name' on SignupBody.");
    }

    return {
      'email': model.email,
      'password': model.password,
      'name': model.name
    };
  }
}

abstract class SignupBodyFields {
  static const List<String> allFields = <String>[email, password, name];

  static const String email = 'email';

  static const String password = 'password';

  static const String name = 'name';
}
