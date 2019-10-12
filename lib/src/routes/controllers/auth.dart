import 'dart:async';
import 'package:angel_auth/angel_auth.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_orm/angel_orm.dart';
import 'package:angel_validate/server.dart';
import 'package:bubble/models.dart';
import 'package:dbcrypt/dbcrypt.dart';

@Expose('/api/auth')
class AuthController extends Controller {
  final QueryExecutor executor;
  final DBCrypt dbCrypt;
  AngelAuth<User> _auth;
  Validator _signupValidator;

  AuthController(this.executor, this.dbCrypt) {
    _signupValidator = Validator({
      'name*': isNonEmptyString,
      'email*': isEmail,
      'password*': [isNonEmptyString, isConfirmed]
    });
  }

  @override
  FutureOr<void> configureRoutes(Routable routable) {
    routable.post('/signup', validate(_signupValidator));
  }

  @override
  Future<void> configureServer(Angel app) async {
    await super.configureServer(app);
    _auth = AngelAuth();
    _auth.serializer = (u) => u.id;
    _auth.deserializer = (idObj) {
      var id = int.parse(idObj.toString());
      var query = UserQuery()..where.id.equals(id);
      return query.getOne(executor);
    };
    _auth.strategies['local'] = LocalAuthStrategy(
      (email, password) async {
        // TODO: Brute-force protection.
        // Find the user with that email.
        var query = UserQuery()..where.email.equals(email.toLowerCase());
        var user = await query.getOne(executor);
        if (user != null) {
          var hashed = dbCrypt.hashpw(password, user.salt);
          if (hashed != user.hashedPassword) {
            throw AngelHttpException.notAuthenticated(
                message: 'Invalid password.');
          }
        }
        return user;
      },
      usernameField: 'email',
    );
    await app.configure(_auth.configureServer);
  }

  @Expose('/login', method: 'POST')
  RequestHandler login() => _auth.authenticate('local');

  @Expose('/resume', method: 'POST')
  RequestHandler resume() => _auth.reviveJwt;

  @Expose('/signup', method: 'POST')
  Future<Map<String, dynamic>> signup(RequestContext req) async {
    // TODO: Brute-force protection.
    // TODO: Send confirmation emails.
    // Parse the request body.
    var body = await req.decodeBody(signupBodySerializer);
    // See if a user exists with that email.
    var existingQuery = UserQuery()..where.email.equals(body.lowerEmail);
    var existing = await existingQuery.getOne(executor);
    if (existing != null) {
      throw AngelHttpException.forbidden(
          message: 'An account with that email already exists.');
    }

    // Otherwise, create a new user, and sign them in.
    var now = DateTime.now().toUtc();
    var salt = dbCrypt.gensalt();
    var query = UserQuery();
    query.values
      ..email = body.lowerEmail
      ..name = body.name
      ..salt = salt
      ..hashedPassword = dbCrypt.hashpw(body.password, salt)
      ..isAvatarVerified = false
      ..isEmailConfirmed = false
      ..createdAt = now
      ..updatedAt = now;

    // Return a JWT token pointing to the user.
    var user = await query.insert(executor);
    var token = AuthToken(ipAddress: req.ip, userId: user.id, issuedAt: now);
    return {
      'data': user,
      'token': token.serialize(_auth.hmac),
    };
  }
}
