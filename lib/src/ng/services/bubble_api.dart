import 'dart:async';
import 'package:angel_http_exception/angel_http_exception.dart';
import 'package:angel_serialize/angel_serialize.dart';
import 'package:angular/angular.dart';
import 'package:http/http.dart' as http;
import 'package:bubble/models.dart';

@Injectable()
class BubbleApiService {
  final http.Client httpClient = http.Client();
  String _token;
  User _user;

  bool get isLoggedIn => user != null;

  User get user => _user;

  Future<void> initialize() async {
    // TODO: Resume from offline, etc.
  }

  http.Response verifyResponse(http.Response rs) {
    if (rs.statusCode != 200 && rs.statusCode != 201) {
      throw AngelHttpException.fromJson(rs.body);
    }
    return rs;
  }

  Future<void> _handleAuth(http.Response response) async {
    var auth = json.decode(response.body) as Map<String, dynamic>;
    _token = auth['token'] as String;
    _user = userSerializer.decode(auth['data'] as Map);
  }

  Future<void> login(Map<String, dynamic> data) async {
    // TODO: Save auth information
    // TODO: Use credentials API if available
    // TODO: Request notification permission
    var response = await httpClient
        .post('/api/auth/login', body: data)
        .then(verifyResponse);
    await _handleAuth(response);
  }

  Future<void> signup(Map<String, dynamic> data) async {
    var response = await httpClient
        .post('/api/auth/signup', body: data)
        .then(verifyResponse);
    await _handleAuth(response);
  }
}
