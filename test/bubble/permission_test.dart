import 'package:angel_orm/angel_orm.dart';
import 'package:angel_test/angel_test.dart';
import 'package:bubble/src/routes/controllers/bubble.dart';
import 'package:bubble/models.dart';
import 'package:test/test.dart';
import '../common.dart';

main() async {
  TestClient client;
  QueryExecutor executor;
  BubbleController bubbleController;
  var ids = <int>[];

  Bubble socksBubble;

  setUp(() async {
    client = await connectToApp();
    executor = client.server.container.make<QueryExecutor>();
    bubbleController = client.server.container.make<BubbleController>();

    var socksBubbleQuery = BubbleQuery();
    socksBubbleQuery.values
      ..type = BubbleType.general
      ..name = 'Socks'
      ..description = 'All about socks.';
    socksBubble = await socksBubbleQuery.insert(executor);
  });

  tearDown(() async {
    if (ids.isNotEmpty) {
      var query = BubbleQuery()..where.id.isIn(ids);
      await query.delete(executor);
    }

    ids.clear();
    await client?.close();
  });

  test('hey', () async {
    print(socksBubble);
    print(bubbleController.routeMappings);
  });
}
