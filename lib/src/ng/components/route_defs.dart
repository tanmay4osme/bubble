import 'package:angular_router/angular_router.dart';
import 'bubble_home.template.dart' as ng;
import 'bubble_login.template.dart' as ng;

abstract class RouteDefs {
  static final List<RouteDefinition> all = [
    RouteDefinition(
      path: '/',
      component: ng.BubbleHomeComponentNgFactory,
    ),
    RouteDefinition(
      path: '/login',
      component: ng.BubbleLoginComponentNgFactory,
    ),
  ];
}
