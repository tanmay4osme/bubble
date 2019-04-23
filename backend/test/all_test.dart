import 'dart:async';
import 'dart:io';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_migration_runner/angel_migration_runner.dart';
import 'package:angel_test/angel_test.dart';
import 'package:backend/src/pretty_logging.dart';
import 'package:backend/backend.dart' as backend;
import 'package:backend/migration.dart';
import 'package:logging/logging.dart';
import 'package:test/test.dart';

const testingEnv = AngelEnvironment('testing');

main() async {
  TestClient client;

  Future<void> psql(String query) async {
    var p = await Process.start('psql', ['-c', query],
        mode: ProcessStartMode.inheritStdio);
    var code = await p.exitCode;
    if (code != 0) {
      exitCode = 0;
      throw StateError('`psql` failure.');
    }
  }

  setUp(() async {
    hierarchicalLoggingEnabled = true;
    // await psql('DROP DATABASE IF EXISTS bubble_test;');
    // await psql('CREATE DATABASE bubble_test;');
    var logger = Logger.detached('bubble_test')..onRecord.listen(prettyLog);
    var app = Angel(logger: logger);
    var runner = await createMigrationRunner(testingEnv);
    await runMigrations(runner, ['refresh']);
    await backend.configureServer(app, testingEnv);
    client = await connectTo(app);
  });

  tearDown(() async {
    await client?.close();
    // await psql('DROP DATABASE IF EXISTS bubble_test;');
  });

  test('hey', () async {
    print('...');
  });
}
