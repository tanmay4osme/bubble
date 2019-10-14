import 'dart:async';
import 'package:angular_router/angular_router.dart';
import 'package:bubble/models.dart';
import 'package:bubble/src/ng/services/bubble_api.dart';

abstract class AuthGuardedComponent implements CanActivate {
  final BubbleApiService api;

  AuthGuardedComponent(this.api);

  User get user => api.user;

  @override
  Future<bool> canActivate(RouterState current, RouterState next) {
    return Future.value(api.isLoggedIn);
  }
}
