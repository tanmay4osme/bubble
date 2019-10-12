import 'package:angel_migration/angel_migration.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:http_parser/http_parser.dart';
part 'models.g.dart';

enum BubbleType {
  aggregate,
  profile,
  general,
}

@serializable
@orm
class _Bubble extends Model {
  @notNull
  BubbleType type;

  int ownerId;

  @notNull
  String name;

  @notNull
  String description;

  @hasMany
  List<_PostShare> shares;

  @hasMany
  List<_BubbleAggregationRule> aggregationRules;
}

@serializable
@orm
class _BubbleAggregationRule extends Model {
  int bubbleId;

  int targetBubbleId;

  int targetUserId;
}

enum PostType {
  text,
  link,
  media,
}

@serializable
@orm
class _Post extends Model {
  @notNull
  PostType type;

  @BelongsTo(localKey: 'posted_by')
  _User user;
}

@serializable
@orm
class _PostShare {
  @notNull
  int bubbleId;

  @BelongsTo(localKey: 'shared_by')
  _User user;

  @belongsTo
  _Post post;
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
class _Subscription {
  @belongsTo
  _Bubble bubble;

  @belongsTo
  _User user;

  @notNull
  BubblePermission permission;
}

@serializable
@orm
class _User extends Model {
  String name;

  @Column(indexType: IndexType.unique)
  String email;

  @Exclude(canDeserialize: true)
  String salt, hashedPassword;

  @DefaultsTo(false)
  bool isEmailConfirmed;

  @DefaultsTo(false)
  bool isAvatarVerified;

  @hasOne
  _Upload avatar;

  bool get canPost {
    return isEmailConfirmed && isAvatarVerified;
  }
}

@serializable
@orm
class _Upload extends Model {
  @Exclude(canDeserialize: true)
  String path;
  String mimeType;
  int userId, sizeInBytes;

  MediaType get mediaType => MediaType.parse(mimeType);
}

// Config

@serializable
class _BubbleConfig {}

@serializable
class _BubbleThemeConfig {}

@serializable
class _LoginBody {
  @notNull
  String name, email, password;
  String _lowerEmail;

  String get lowerEmail => _lowerEmail ??= email.toLowerCase();
}
