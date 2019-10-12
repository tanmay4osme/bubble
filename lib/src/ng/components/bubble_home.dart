import 'package:angular/angular.dart';
import 'bubble_sidebar.dart';
import 'bubble_timeline.dart';

@Component(
    selector: 'bubble-home',
    templateUrl: 'bubble_home.html',
    directives: [BubbleSidebarComponent, BubbleTimelineComponent],
    styleUrls: ['package:bubble/src/sass/home.css'])
class BubbleHomeComponent {}
