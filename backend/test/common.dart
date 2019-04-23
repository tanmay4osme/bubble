import 'dart:async';
import 'package:angel_container/mirrors.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_migration_runner/angel_migration_runner.dart';
import 'package:angel_test/angel_test.dart';
import 'package:backend/src/pretty_logging.dart';
import 'package:backend/backend.dart' as backend;
import 'package:backend/migration.dart';
import 'package:logging/logging.dart';

const testingEnv = AngelEnvironment('testing');

Future<TestClient> connectToApp() async {
  hierarchicalLoggingEnabled = true;
  var logger = Logger.detached('bubble_test')..onRecord.listen(prettyLog);
  var app = Angel(
      logger: logger, environment: testingEnv, reflector: MirrorsReflector());
  var runner = await createMigrationRunner(testingEnv);
  await runMigrations(runner, ['refresh']);
  await backend.configureServer(app, testingEnv);
  return await connectTo(app);
}
