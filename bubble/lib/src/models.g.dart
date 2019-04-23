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
      table.integer('type');
      table.integer('owner_id');
      table.varChar('name');
      table.varChar('description');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
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
      table.integer('bubble_id');
      table.integer('target_bubble_id');
      table.integer('target_user_id');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
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
      table.integer('type');
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
      table.integer('posted_by').references('users', 'id');
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
      table.integer('shared_by').references('users', 'id');
      table.integer('post_id').references('posts', 'id');
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
      table.integer('bubble_id').references('bubbles', 'id');
      table.integer('user_id').references('users', 'id');
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
      table.varChar('username');
      table.varChar('salt');
      table.varChar('hashed_password');
      table.boolean('is_email_confirmed')..defaultsTo(false);
      table.boolean('is_avatar_verified')..defaultsTo(false);
      table.timeStamp('created_at');
      table.timeStamp('updated_at');
    });
  }

  @override
  down(Schema schema) {
    schema.drop('users');
  }
}

// **************************************************************************
// OrmGenerator
// **************************************************************************

class BubbleQuery extends Query<Bubble, BubbleQueryWhere> {
  BubbleQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = BubbleQueryWhere(this);
    leftJoin(PostShareQuery(trampoline: trampoline), 'id', 'bubble_id',
        additionalFields: const ['bubble_id', 'shared_by', 'post_id'],
        trampoline: trampoline);
    leftJoin(
        BubbleAggregationRuleQuery(trampoline: trampoline), 'id', 'bubble_id',
        additionalFields: const [
          'id',
          'bubble_id',
          'target_bubble_id',
          'target_user_id',
          'created_at',
          'updated_at'
        ],
        trampoline: trampoline);
  }

  @override
  final BubbleQueryValues values = BubbleQueryValues();

  BubbleQueryWhere _where;

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
      'type',
      'owner_id',
      'name',
      'description',
      'created_at',
      'updated_at'
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
        type: row[1] == null ? null : BubbleType.values[(row[1] as int)],
        ownerId: (row[2] as int),
        name: (row[3] as String),
        description: (row[4] as String),
        createdAt: (row[5] as DateTime),
        updatedAt: (row[6] as DateTime));
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
        type =
            EnumSqlExpressionBuilder<BubbleType>(query, 'type', (v) => v.index),
        ownerId = NumericSqlExpressionBuilder<int>(query, 'owner_id'),
        name = StringSqlExpressionBuilder(query, 'name'),
        description = StringSqlExpressionBuilder(query, 'description'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final EnumSqlExpressionBuilder<BubbleType> type;

  final NumericSqlExpressionBuilder<int> ownerId;

  final StringSqlExpressionBuilder name;

  final StringSqlExpressionBuilder description;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, type, ownerId, name, description, createdAt, updatedAt];
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
  BubbleType get type {
    return BubbleType.values[(values['type'] as int)];
  }

  set type(BubbleType value) => values['type'] = value?.index;
  int get ownerId {
    return (values['owner_id'] as int);
  }

  set ownerId(int value) => values['owner_id'] = value;
  String get name {
    return (values['name'] as String);
  }

  set name(String value) => values['name'] = value;
  String get description {
    return (values['description'] as String);
  }

  set description(String value) => values['description'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(Bubble model) {
    type = model.type;
    ownerId = model.ownerId;
    name = model.name;
    description = model.description;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }
}

class BubbleAggregationRuleQuery
    extends Query<BubbleAggregationRule, BubbleAggregationRuleQueryWhere> {
  BubbleAggregationRuleQuery({Set<String> trampoline}) {
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
      'bubble_id',
      'target_bubble_id',
      'target_user_id',
      'created_at',
      'updated_at'
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
        bubbleId: (row[1] as int),
        targetBubbleId: (row[2] as int),
        targetUserId: (row[3] as int),
        createdAt: (row[4] as DateTime),
        updatedAt: (row[5] as DateTime));
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
        bubbleId = NumericSqlExpressionBuilder<int>(query, 'bubble_id'),
        targetBubbleId =
            NumericSqlExpressionBuilder<int>(query, 'target_bubble_id'),
        targetUserId =
            NumericSqlExpressionBuilder<int>(query, 'target_user_id'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final NumericSqlExpressionBuilder<int> bubbleId;

  final NumericSqlExpressionBuilder<int> targetBubbleId;

  final NumericSqlExpressionBuilder<int> targetUserId;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, bubbleId, targetBubbleId, targetUserId, createdAt, updatedAt];
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
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(BubbleAggregationRule model) {
    bubbleId = model.bubbleId;
    targetBubbleId = model.targetBubbleId;
    targetUserId = model.targetUserId;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }
}

class PostQuery extends Query<Post, PostQueryWhere> {
  PostQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = PostQueryWhere(this);
    leftJoin('users', 'posted_by', 'id',
        additionalFields: const [
          'id',
          'username',
          'salt',
          'hashed_password',
          'is_email_confirmed',
          'is_avatar_verified',
          'created_at',
          'updated_at'
        ],
        trampoline: trampoline);
  }

  @override
  final PostQueryValues values = PostQueryValues();

  PostQueryWhere _where;

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
    return const ['id', 'type', 'posted_by', 'created_at', 'updated_at'];
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
        type: row[1] == null ? null : PostType.values[(row[1] as int)],
        createdAt: (row[3] as DateTime),
        updatedAt: (row[4] as DateTime));
    if (row.length > 5) {
      model = model.copyWith(
          user: UserQuery.parseRow(row.skip(5).take(8).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class PostQueryWhere extends QueryWhere {
  PostQueryWhere(PostQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        type =
            EnumSqlExpressionBuilder<PostType>(query, 'type', (v) => v.index),
        postedBy = NumericSqlExpressionBuilder<int>(query, 'posted_by'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final EnumSqlExpressionBuilder<PostType> type;

  final NumericSqlExpressionBuilder<int> postedBy;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [id, type, postedBy, createdAt, updatedAt];
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
  PostType get type {
    return PostType.values[(values['type'] as int)];
  }

  set type(PostType value) => values['type'] = value?.index;
  int get postedBy {
    return (values['posted_by'] as int);
  }

  set postedBy(int value) => values['posted_by'] = value;
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(Post model) {
    type = model.type;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
    if (model.user != null) {
      values['posted_by'] = model.user.id;
    }
  }
}

class PostShareQuery extends Query<PostShare, PostShareQueryWhere> {
  PostShareQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = PostShareQueryWhere(this);
    leftJoin('users', 'shared_by', 'id',
        additionalFields: const [
          'id',
          'username',
          'salt',
          'hashed_password',
          'is_email_confirmed',
          'is_avatar_verified',
          'created_at',
          'updated_at'
        ],
        trampoline: trampoline);
    leftJoin('posts', 'post_id', 'id',
        additionalFields: const [
          'id',
          'type',
          'posted_by',
          'created_at',
          'updated_at'
        ],
        trampoline: trampoline);
  }

  @override
  final PostShareQueryValues values = PostShareQueryValues();

  PostShareQueryWhere _where;

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
          user: UserQuery.parseRow(row.skip(3).take(8).toList()));
    }
    if (row.length > 11) {
      model = model.copyWith(
          post: PostQuery.parseRow(row.skip(11).take(5).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
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
  SubscriptionQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = SubscriptionQueryWhere(this);
    leftJoin('bubbles', 'bubble_id', 'id',
        additionalFields: const [
          'id',
          'type',
          'owner_id',
          'name',
          'description',
          'created_at',
          'updated_at'
        ],
        trampoline: trampoline);
    leftJoin('users', 'user_id', 'id',
        additionalFields: const [
          'id',
          'username',
          'salt',
          'hashed_password',
          'is_email_confirmed',
          'is_avatar_verified',
          'created_at',
          'updated_at'
        ],
        trampoline: trampoline);
  }

  @override
  final SubscriptionQueryValues values = SubscriptionQueryValues();

  SubscriptionQueryWhere _where;

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
          user: UserQuery.parseRow(row.skip(10).take(8).toList()));
    }
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
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
  UserQuery({Set<String> trampoline}) {
    trampoline ??= Set();
    trampoline.add(tableName);
    _where = UserQueryWhere(this);
  }

  @override
  final UserQueryValues values = UserQueryValues();

  UserQueryWhere _where;

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
      'username',
      'salt',
      'hashed_password',
      'is_email_confirmed',
      'is_avatar_verified',
      'created_at',
      'updated_at'
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
        username: (row[1] as String),
        salt: (row[2] as String),
        hashedPassword: (row[3] as String),
        isEmailConfirmed: (row[4] as bool),
        isAvatarVerified: (row[5] as bool),
        createdAt: (row[6] as DateTime),
        updatedAt: (row[7] as DateTime));
    return model;
  }

  @override
  deserialize(List row) {
    return parseRow(row);
  }
}

class UserQueryWhere extends QueryWhere {
  UserQueryWhere(UserQuery query)
      : id = NumericSqlExpressionBuilder<int>(query, 'id'),
        username = StringSqlExpressionBuilder(query, 'username'),
        salt = StringSqlExpressionBuilder(query, 'salt'),
        hashedPassword = StringSqlExpressionBuilder(query, 'hashed_password'),
        isEmailConfirmed =
            BooleanSqlExpressionBuilder(query, 'is_email_confirmed'),
        isAvatarVerified =
            BooleanSqlExpressionBuilder(query, 'is_avatar_verified'),
        createdAt = DateTimeSqlExpressionBuilder(query, 'created_at'),
        updatedAt = DateTimeSqlExpressionBuilder(query, 'updated_at');

  final NumericSqlExpressionBuilder<int> id;

  final StringSqlExpressionBuilder username;

  final StringSqlExpressionBuilder salt;

  final StringSqlExpressionBuilder hashedPassword;

  final BooleanSqlExpressionBuilder isEmailConfirmed;

  final BooleanSqlExpressionBuilder isAvatarVerified;

  final DateTimeSqlExpressionBuilder createdAt;

  final DateTimeSqlExpressionBuilder updatedAt;

  @override
  get expressionBuilders {
    return [
      id,
      username,
      salt,
      hashedPassword,
      isEmailConfirmed,
      isAvatarVerified,
      createdAt,
      updatedAt
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
  String get username {
    return (values['username'] as String);
  }

  set username(String value) => values['username'] = value;
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
  DateTime get createdAt {
    return (values['created_at'] as DateTime);
  }

  set createdAt(DateTime value) => values['created_at'] = value;
  DateTime get updatedAt {
    return (values['updated_at'] as DateTime);
  }

  set updatedAt(DateTime value) => values['updated_at'] = value;
  void copyFrom(User model) {
    username = model.username;
    salt = model.salt;
    hashedPassword = model.hashedPassword;
    isEmailConfirmed = model.isEmailConfirmed;
    isAvatarVerified = model.isAvatarVerified;
    createdAt = model.createdAt;
    updatedAt = model.updatedAt;
  }
}

// **************************************************************************
// JsonModelGenerator
// **************************************************************************

@generatedSerializable
class Bubble extends _Bubble {
  Bubble(
      {this.id,
      @required this.type,
      this.ownerId,
      @required this.name,
      @required this.description,
      List<_PostShare> shares,
      List<_BubbleAggregationRule> aggregationRules,
      this.createdAt,
      this.updatedAt})
      : this.shares = new List.unmodifiable(shares ?? []),
        this.aggregationRules = new List.unmodifiable(aggregationRules ?? []);

  @override
  final String id;

  @override
  final BubbleType type;

  @override
  final int ownerId;

  @override
  final String name;

  @override
  final String description;

  @override
  final List<_PostShare> shares;

  @override
  final List<_BubbleAggregationRule> aggregationRules;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Bubble copyWith(
      {String id,
      BubbleType type,
      int ownerId,
      String name,
      String description,
      List<_PostShare> shares,
      List<_BubbleAggregationRule> aggregationRules,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Bubble(
        id: id ?? this.id,
        type: type ?? this.type,
        ownerId: ownerId ?? this.ownerId,
        name: name ?? this.name,
        description: description ?? this.description,
        shares: shares ?? this.shares,
        aggregationRules: aggregationRules ?? this.aggregationRules,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Bubble &&
        other.id == id &&
        other.type == type &&
        other.ownerId == ownerId &&
        other.name == name &&
        other.description == description &&
        const ListEquality<_PostShare>(const DefaultEquality<_PostShare>())
            .equals(other.shares, shares) &&
        const ListEquality<_BubbleAggregationRule>(
                const DefaultEquality<_BubbleAggregationRule>())
            .equals(other.aggregationRules, aggregationRules) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      type,
      ownerId,
      name,
      description,
      shares,
      aggregationRules,
      createdAt,
      updatedAt
    ]);
  }

  @override
  String toString() {
    return "Bubble(id=$id, type=$type, ownerId=$ownerId, name=$name, description=$description, shares=$shares, aggregationRules=$aggregationRules, createdAt=$createdAt, updatedAt=$updatedAt)";
  }

  Map<String, dynamic> toJson() {
    return BubbleSerializer.toMap(this);
  }
}

@generatedSerializable
class BubbleAggregationRule extends _BubbleAggregationRule {
  BubbleAggregationRule(
      {this.id,
      this.bubbleId,
      this.targetBubbleId,
      this.targetUserId,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final int bubbleId;

  @override
  final int targetBubbleId;

  @override
  final int targetUserId;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  BubbleAggregationRule copyWith(
      {String id,
      int bubbleId,
      int targetBubbleId,
      int targetUserId,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new BubbleAggregationRule(
        id: id ?? this.id,
        bubbleId: bubbleId ?? this.bubbleId,
        targetBubbleId: targetBubbleId ?? this.targetBubbleId,
        targetUserId: targetUserId ?? this.targetUserId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _BubbleAggregationRule &&
        other.id == id &&
        other.bubbleId == bubbleId &&
        other.targetBubbleId == targetBubbleId &&
        other.targetUserId == targetUserId &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects(
        [id, bubbleId, targetBubbleId, targetUserId, createdAt, updatedAt]);
  }

  @override
  String toString() {
    return "BubbleAggregationRule(id=$id, bubbleId=$bubbleId, targetBubbleId=$targetBubbleId, targetUserId=$targetUserId, createdAt=$createdAt, updatedAt=$updatedAt)";
  }

  Map<String, dynamic> toJson() {
    return BubbleAggregationRuleSerializer.toMap(this);
  }
}

@generatedSerializable
class Post extends _Post {
  Post(
      {this.id,
      @required this.type,
      this.user,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final PostType type;

  @override
  final _User user;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  Post copyWith(
      {String id,
      PostType type,
      _User user,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new Post(
        id: id ?? this.id,
        type: type ?? this.type,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _Post &&
        other.id == id &&
        other.type == type &&
        other.user == user &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([id, type, user, createdAt, updatedAt]);
  }

  @override
  String toString() {
    return "Post(id=$id, type=$type, user=$user, createdAt=$createdAt, updatedAt=$updatedAt)";
  }

  Map<String, dynamic> toJson() {
    return PostSerializer.toMap(this);
  }
}

@generatedSerializable
class PostShare implements _PostShare {
  const PostShare({@required this.bubbleId, this.user, this.post});

  @override
  final int bubbleId;

  @override
  final _User user;

  @override
  final _Post post;

  PostShare copyWith({int bubbleId, _User user, _Post post}) {
    return new PostShare(
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
class Subscription implements _Subscription {
  const Subscription({this.bubble, this.user, @required this.permission});

  @override
  final _Bubble bubble;

  @override
  final _User user;

  @override
  final BubblePermission permission;

  Subscription copyWith(
      {_Bubble bubble, _User user, BubblePermission permission}) {
    return new Subscription(
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
      @required this.username,
      @required this.salt,
      @required this.hashedPassword,
      this.isEmailConfirmed = false,
      this.isAvatarVerified = false,
      this.createdAt,
      this.updatedAt});

  @override
  final String id;

  @override
  final String username;

  @override
  final String salt;

  @override
  final String hashedPassword;

  @override
  final bool isEmailConfirmed;

  @override
  final bool isAvatarVerified;

  @override
  final DateTime createdAt;

  @override
  final DateTime updatedAt;

  User copyWith(
      {String id,
      String username,
      String salt,
      String hashedPassword,
      bool isEmailConfirmed,
      bool isAvatarVerified,
      DateTime createdAt,
      DateTime updatedAt}) {
    return new User(
        id: id ?? this.id,
        username: username ?? this.username,
        salt: salt ?? this.salt,
        hashedPassword: hashedPassword ?? this.hashedPassword,
        isEmailConfirmed: isEmailConfirmed ?? this.isEmailConfirmed,
        isAvatarVerified: isAvatarVerified ?? this.isAvatarVerified,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt);
  }

  bool operator ==(other) {
    return other is _User &&
        other.id == id &&
        other.username == username &&
        other.salt == salt &&
        other.hashedPassword == hashedPassword &&
        other.isEmailConfirmed == isEmailConfirmed &&
        other.isAvatarVerified == isAvatarVerified &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return hashObjects([
      id,
      username,
      salt,
      hashedPassword,
      isEmailConfirmed,
      isAvatarVerified,
      createdAt,
      updatedAt
    ]);
  }

  @override
  String toString() {
    return "User(id=$id, username=$username, salt=$salt, hashedPassword=$hashedPassword, isEmailConfirmed=$isEmailConfirmed, isAvatarVerified=$isAvatarVerified, createdAt=$createdAt, updatedAt=$updatedAt)";
  }

  Map<String, dynamic> toJson() {
    return UserSerializer.toMap(this);
  }
}

// **************************************************************************
// SerializerGenerator
// **************************************************************************

const BubbleSerializer bubbleSerializer = const BubbleSerializer();

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
      throw new FormatException("Missing required field 'type' on Bubble.");
    }

    if (map['name'] == null) {
      throw new FormatException("Missing required field 'name' on Bubble.");
    }

    if (map['description'] == null) {
      throw new FormatException(
          "Missing required field 'description' on Bubble.");
    }

    return new Bubble(
        id: map['id'] as String,
        type: map['type'] is BubbleType
            ? (map['type'] as BubbleType)
            : (map['type'] is int
                ? BubbleType.values[map['type'] as int]
                : null),
        ownerId: map['owner_id'] as int,
        name: map['name'] as String,
        description: map['description'] as String,
        shares: map['shares'] is Iterable
            ? new List.unmodifiable(
                ((map['shares'] as Iterable).where((x) => x is Map))
                    .cast<Map>()
                    .map(PostShareSerializer.fromMap))
            : null,
        aggregationRules: map['aggregation_rules'] is Iterable
            ? new List.unmodifiable(
                ((map['aggregation_rules'] as Iterable).where((x) => x is Map))
                    .cast<Map>()
                    .map(BubbleAggregationRuleSerializer.fromMap))
            : null,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_Bubble model) {
    if (model == null) {
      return null;
    }
    if (model.type == null) {
      throw new FormatException("Missing required field 'type' on Bubble.");
    }

    if (model.name == null) {
      throw new FormatException("Missing required field 'name' on Bubble.");
    }

    if (model.description == null) {
      throw new FormatException(
          "Missing required field 'description' on Bubble.");
    }

    return {
      'id': model.id,
      'type': model.type == null ? null : BubbleType.values.indexOf(model.type),
      'owner_id': model.ownerId,
      'name': model.name,
      'description': model.description,
      'shares':
          model.shares?.map((m) => PostShareSerializer.toMap(m))?.toList(),
      'aggregation_rules': model.aggregationRules
          ?.map((m) => BubbleAggregationRuleSerializer.toMap(m))
          ?.toList(),
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class BubbleFields {
  static const List<String> allFields = <String>[
    id,
    type,
    ownerId,
    name,
    description,
    shares,
    aggregationRules,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String type = 'type';

  static const String ownerId = 'owner_id';

  static const String name = 'name';

  static const String description = 'description';

  static const String shares = 'shares';

  static const String aggregationRules = 'aggregation_rules';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}

const BubbleAggregationRuleSerializer bubbleAggregationRuleSerializer =
    const BubbleAggregationRuleSerializer();

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
    return new BubbleAggregationRule(
        id: map['id'] as String,
        bubbleId: map['bubble_id'] as int,
        targetBubbleId: map['target_bubble_id'] as int,
        targetUserId: map['target_user_id'] as int,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_BubbleAggregationRule model) {
    if (model == null) {
      return null;
    }
    return {
      'id': model.id,
      'bubble_id': model.bubbleId,
      'target_bubble_id': model.targetBubbleId,
      'target_user_id': model.targetUserId,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class BubbleAggregationRuleFields {
  static const List<String> allFields = <String>[
    id,
    bubbleId,
    targetBubbleId,
    targetUserId,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String bubbleId = 'bubble_id';

  static const String targetBubbleId = 'target_bubble_id';

  static const String targetUserId = 'target_user_id';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}

const PostSerializer postSerializer = const PostSerializer();

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
      throw new FormatException("Missing required field 'type' on Post.");
    }

    return new Post(
        id: map['id'] as String,
        type: map['type'] is PostType
            ? (map['type'] as PostType)
            : (map['type'] is int ? PostType.values[map['type'] as int] : null),
        user: map['user'] != null
            ? UserSerializer.fromMap(map['user'] as Map)
            : null,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_Post model) {
    if (model == null) {
      return null;
    }
    if (model.type == null) {
      throw new FormatException("Missing required field 'type' on Post.");
    }

    return {
      'id': model.id,
      'type': model.type == null ? null : PostType.values.indexOf(model.type),
      'user': UserSerializer.toMap(model.user),
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class PostFields {
  static const List<String> allFields = <String>[
    id,
    type,
    user,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String type = 'type';

  static const String user = 'user';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}

const PostShareSerializer postShareSerializer = const PostShareSerializer();

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
      throw new FormatException(
          "Missing required field 'bubble_id' on PostShare.");
    }

    return new PostShare(
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
      throw new FormatException(
          "Missing required field 'bubble_id' on PostShare.");
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

const SubscriptionSerializer subscriptionSerializer =
    const SubscriptionSerializer();

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
      throw new FormatException(
          "Missing required field 'permission' on Subscription.");
    }

    return new Subscription(
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
      throw new FormatException(
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

const UserSerializer userSerializer = const UserSerializer();

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
    if (map['username'] == null) {
      throw new FormatException("Missing required field 'username' on User.");
    }

    if (map['salt'] == null) {
      throw new FormatException("Missing required field 'salt' on User.");
    }

    if (map['hashed_password'] == null) {
      throw new FormatException(
          "Missing required field 'hashed_password' on User.");
    }

    return new User(
        id: map['id'] as String,
        username: map['username'] as String,
        salt: map['salt'] as String,
        hashedPassword: map['hashed_password'] as String,
        isEmailConfirmed: map['is_email_confirmed'] as bool ?? false,
        isAvatarVerified: map['is_avatar_verified'] as bool ?? false,
        createdAt: map['created_at'] != null
            ? (map['created_at'] is DateTime
                ? (map['created_at'] as DateTime)
                : DateTime.parse(map['created_at'].toString()))
            : null,
        updatedAt: map['updated_at'] != null
            ? (map['updated_at'] is DateTime
                ? (map['updated_at'] as DateTime)
                : DateTime.parse(map['updated_at'].toString()))
            : null);
  }

  static Map<String, dynamic> toMap(_User model) {
    if (model == null) {
      return null;
    }
    if (model.username == null) {
      throw new FormatException("Missing required field 'username' on User.");
    }

    if (model.salt == null) {
      throw new FormatException("Missing required field 'salt' on User.");
    }

    if (model.hashedPassword == null) {
      throw new FormatException(
          "Missing required field 'hashed_password' on User.");
    }

    return {
      'id': model.id,
      'username': model.username,
      'salt': model.salt,
      'hashed_password': model.hashedPassword,
      'is_email_confirmed': model.isEmailConfirmed,
      'is_avatar_verified': model.isAvatarVerified,
      'created_at': model.createdAt?.toIso8601String(),
      'updated_at': model.updatedAt?.toIso8601String()
    };
  }
}

abstract class UserFields {
  static const List<String> allFields = <String>[
    id,
    username,
    salt,
    hashedPassword,
    isEmailConfirmed,
    isAvatarVerified,
    createdAt,
    updatedAt
  ];

  static const String id = 'id';

  static const String username = 'username';

  static const String salt = 'salt';

  static const String hashedPassword = 'hashed_password';

  static const String isEmailConfirmed = 'is_email_confirmed';

  static const String isAvatarVerified = 'is_avatar_verified';

  static const String createdAt = 'created_at';

  static const String updatedAt = 'updated_at';
}
