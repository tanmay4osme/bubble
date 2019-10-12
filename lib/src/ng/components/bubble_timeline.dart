import 'package:angular/angular.dart';
import 'bubble_post_card.dart';

@Component(
    selector: 'bubble-timeline',
    templateUrl: 'bubble_timeline.html',
    directives: [BubblePostCardComponent],
    styleUrls: ['package:bubble/src/sass/timeline.css'])
class BubbleTimelineComponent {}
