import 'dart:async';
import 'dart:html';
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
    // Resume from offline, etc.
    http.Response response;
    if (window.navigator.credentials == null) {
      var token = window.localStorage['token'];
      if (token != null) {
        response =
            await httpClient.post('/api/auth/resume', body: {'token': token});
      }
    } else {
      var credentials = await window.navigator.credentials
          .get({'password': true}) as PasswordCredential;
      if (credentials != null) {
        response = await httpClient.post('/api/auth/login',
            body: {'email': credentials.id, 'password': credentials.password});
      }
    }

    if (response != null) {
      try {
        verifyResponse(response);
        await _handleAuth(response, null);
      } on AngelHttpException {
        if (window.navigator.credentials == null) {
          window.localStorage.remove('token');
        } else {
          await window.navigator.credentials.preventSilentAccess();
        }
      }
    }
  }

  http.Response verifyResponse(http.Response rs) {
    if (rs.statusCode != 200 && rs.statusCode != 201) {
      throw AngelHttpException.fromJson(rs.body);
    }
    return rs;
  }

  Future<void> _handleAuth(http.Response response, String password) async {
    var auth = json.decode(response.body) as Map<String, dynamic>;
    _token = auth['token'] as String;
    _user = userSerializer.decode(auth['data'] as Map);

    if (window.navigator.credentials == null) {
      window.localStorage['token'] = _token;
    } else if (password != null) {
      await window.navigator.credentials.store(PasswordCredential({
        'id': _user.email,
        'name': _user.name,
        'password': password,
        'iconURL': Uri.base.replace(path: _user.avatarUrl),
      }));
    }
  }

  Future<void> login(Map<String, dynamic> data) async {
    // TODO: Save auth information
    // TODO: Use credentials API if available
    // TODO: Request notification permission
    var response = await httpClient
        .post('/api/auth/login', body: data)
        .then(verifyResponse);
    await _handleAuth(response, data['password'] as String);
  }

  Future<void> signup(Map<String, dynamic> data) async {
    var response = await httpClient
        .post('/api/auth/signup', body: data)
        .then(verifyResponse);
    await _handleAuth(response, data['password'] as String);
  }
}
