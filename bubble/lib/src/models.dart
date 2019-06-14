import 'package:angel_migration/angel_migration.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';
part 'models.g.dart';

const serializable = Serializable(serializers: Serializers.all);

enum BubbleType {
  aggregate,
  profile,
  general,
}

@serializable
@orm
abstract class _Bubble extends Model {
  @notNull
  BubbleType get type;

  int get ownerId;

  @notNull
  String get name;

  @notNull
  String get description;

  @hasMany
  List<_PostShare> get shares;

  @hasMany
  List<_BubbleAggregationRule> get aggregationRules;
}

@serializable
@orm
abstract class _BubbleAggregationRule extends Model {
  int get bubbleId;

  int get targetBubbleId;

  int get targetUserId;
}

enum PostType {
  text,
  link,
  media,
}

@serializable
@orm
abstract class _Post extends Model {
  @notNull
  PostType get type;

  @BelongsTo(localKey: 'posted_by')
  _User get user;
}

@serializable
@orm
abstract class _PostShare {
  @notNull
  int get bubbleId;

  @BelongsTo(localKey: 'shared_by')
  _User get user;

  @belongsTo
  _Post get post;
}

enum BubblePermission {
  owner,
  admin,
  moderator,
  canPost,
  commentOnly,
  readOnly,
  banned
}

@serializable
@orm
abstract class _Subscription {
  @belongsTo
  _Bubble get bubble;

  @belongsTo
  _User get user;

  @notNull
  BubblePermission get permission;
}

@serializable
@orm
abstract class _User extends Model {
  @notNull
  String get username;

  @notNull
  String get salt;

  @notNull
  String get hashedPassword;

  @DefaultsTo(false)
  bool get isEmailConfirmed;

  @DefaultsTo(false)
  bool get isAvatarVerified;

  bool get canPost {
    return isEmailConfirmed && isAvatarVerified;
  }
}
