import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:bubble/bubble.dart';

@Expose('/api/bubbles')
class BubbleController extends Controller {
  final QueryExecutor executor;

  BubbleController(this.executor);

  static Future<bool> _parsePost(
      RequestContext req, ResponseContext res) async {
    // TODO: Actual validation
    await req.parseBody();
    var post = postSerializer.decode(req.bodyAsMap);
    req.container.registerSingleton(post);
    return true;
  }

  @Expose('/int:bubbleId/share', method: 'POST', middleware: [_parsePost])
  Future<PostShare> sharePost(int bubbleId, User user, Post post) async {
    // Find the user's subscription, if any.
    var subscriptionQuery = SubscriptionQuery();
    subscriptionQuery.where
      ..bubbleId.equals(bubbleId)
      ..userId.equals(user.idAsInt);
    var subscription = await subscriptionQuery.getOne(executor);

    // Only allow subscribed users to post. (i.e. no bots).
    if (subscription == null) {
      throw AngelHttpException.forbidden(
          message: 'You must be subscribed to this bubble to post to it.');
    }

    // Apply access controls.
    if (subscription.permission.index > BubblePermission.canPost.index) {
      throw AngelHttpException.forbidden(
          message: 'You are not permitted to share posts to this bubble.');
    }

    // Also notify aggregates.
    var aggregateIds = [bubbleId];
    var aggregateQuery = BubbleAggregationRuleQuery()
      ..where.targetBubbleId.equals(bubbleId)
      ..orWhere((w) => w..targetUserId.equals(user.idAsInt));
    aggregateIds.addAll(await aggregateQuery
        .get(executor)
        .then((it) => it.map((r) => r.bubbleId)));

    // Finally, create post shares for each of the aggregates.
    var shares = await Future.wait(aggregateIds.map((id) async {
      var query = PostShareQuery();
      query.values
        ..bubbleId = id
        ..postId = post.idAsInt
        ..sharedBy = user.idAsInt;
      return await query.insert(executor);
    }));

    // Return the relevant share.
    return shares.firstWhere((s) => s.bubbleId == bubbleId);
  }
}
