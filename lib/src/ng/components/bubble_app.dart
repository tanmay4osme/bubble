import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bubble/src/ng/services/bubble_api.dart';
import 'route_defs.dart';

@Component(
    selector: 'bubble-app',
    templateUrl: 'bubble_app.html',
    directives: [coreDirectives, routerDirectives],
    exports: [RouteDefs],
    providers: [BubbleApiService])
class BubbleAppComponent implements OnInit {
  final BubbleApiService api;
  bool isInitialized = false;

  BubbleAppComponent(this.api);

  @override
  void ngOnInit() async {
    try {
      await api.initialize();
    } catch (e) {
      // Do nothing...
      window.console.info(e);
    } finally {
      isInitialized = true;
    }
  }
}
