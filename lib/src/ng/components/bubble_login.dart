import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bubble/src/ng/services/bubble_api.dart';
import 'package:bubble/src/ng/services/title.dart';

@Component(
    selector: 'bubble-login',
    templateUrl: 'bubble_login.html',
    directives: [coreDirectives, formDirectives],
    styles: [':host { flex: 1; }'])
class BubbleLoginComponent implements OnActivate {
  final BubbleApiService _api;
  final TitleService _titleService;
  final Router _router;
  bool isLogin = true, isSending = false;

  BubbleLoginComponent(this._api, this._titleService, this._router);

  String get passwordAutoComplete =>
      isLogin ? 'current-password' : 'new-password';

  void toggle() => isLogin = !isLogin;

  bool isInvalid(NgControl c) => !c.valid && !c.pristine;

  @override
  void onActivate(RouterState previous, RouterState current) {
    _titleService.title = 'Log in';
  }

  Future<void> handleSubmit(ControlGroup group) async {
    isSending = true;
    try {
      if (isLogin) {
        await _api.login(group.value);
        await _router.navigate('/');
      } else {
        await _api.signup(group.value);
        // TODO: Wait for confirmation email
        await _router.navigate('/');
      }
    } catch (e, st) {
      // TODO: Proper error handling
      window.alert(e.toString());
    } finally {
      isSending = false;
    }
  }
}
