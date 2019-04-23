import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';

@Expose('/api/posts')
class PostController extends Controller {
  final QueryExecutor executor;

  PostController(this.executor);
}
