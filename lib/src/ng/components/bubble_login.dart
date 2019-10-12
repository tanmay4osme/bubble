import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bubble/src/ng/services/title.dart';

@Component(
    selector: 'bubble-login',
    templateUrl: 'bubble_login.html',
    directives: [coreDirectives, formDirectives])
class BubbleLoginComponent implements OnActivate {
  final TitleService titleService;
  bool isLogin = true;

  BubbleLoginComponent(this.titleService);

  void toggle() => isLogin = !isLogin;

  @override
  void onActivate(RouterState previous, RouterState current) {
    titleService.title = 'Log in';
  }
}
