import 'package:angel_migration/angel_migration.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angel_orm/angel_orm.dart';
part 'bubble.g.dart';

@serializable
@orm
abstract class _Bubble extends Model {}
