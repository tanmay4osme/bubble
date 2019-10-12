import 'dart:html';
import 'package:angular/angular.dart';

@Injectable()
class TitleService {
  final String defaultTitle;

  TitleService({this.defaultTitle = 'Bubble'});

  set title(String value) {
    if (value.isEmpty) {
      document.title = '$defaultTitle';
    } else {
      document.title = '$value | $defaultTitle';
    }
  }
}
