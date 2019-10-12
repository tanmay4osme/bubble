import 'package:angular/angular.dart';
import 'package:bubble/src/ng/services/bubble_api.dart';
import 'bubble_home.dart';

@Component(
    selector: 'bubble-app',
    templateUrl: 'bubble_app.html',
    directives: [coreDirectives, BubbleHomeComponent],
    providers: [BubbleApi])
class BubbleAppComponent implements OnInit {
  final BubbleApi api;

  BubbleAppComponent(this.api);

  @override
  void ngOnInit() async {
    await api.initialize();
  }
}
