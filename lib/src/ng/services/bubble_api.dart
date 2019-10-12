import 'dart:async';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:http/http.dart' as http;
import 'package:bubble/models.dart';

@Injectable()
class BubbleApiService {
  final http.Client httpClient = http.Client();
  User _user;

  bool get isLoggedIn => user != null;

  User get user => _user;

  Future<void> initialize() async {
    // TODO: Resume from offline, etc.
  }
}
