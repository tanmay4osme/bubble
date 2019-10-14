import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bubble/src/ng/services/bubble_api.dart';
import 'package:bubble/src/ng/services/title.dart';
import 'auth_guarded.dart';
import 'bubble_timeline.dart';

@Component(
    selector: 'my-profile',
    templateUrl: 'my_profile.html',
    styleUrls: ['package:bubble/src/sass/profile.css'],
    directives: [BubbleTimelineComponent])
class MyProfileComponent extends AuthGuardedComponent implements OnActivate {
  final TitleService _titleService;

  MyProfileComponent(BubbleApiService api, this._titleService) : super(api);

  @override
  void onActivate(RouterState previous, RouterState current) {
    _titleService.title = user.name;
  }
}
