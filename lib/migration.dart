import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_migration_runner/postgres.dart';
import 'package:bubble/src/config/plugins/orm.dart';
import 'package:bubble/models.dart';
import 'package:file/local.dart';

Future<PostgresMigrationRunner> createMigrationRunner(
    [AngelEnvironment env = angelEnv]) async {
  var fs = LocalFileSystem();
  var configuration =
      await loadStandaloneConfiguration(fs, overrideEnvironmentName: env.value);
  var connection = await connectToPostgres(configuration);
  return PostgresMigrationRunner(connection, migrations: [
    UserMigration(),
    BubbleMigration(),
    BubbleAggregationRuleMigration(),
    PostMigration(),
    SubscriptionMigration(),
    PostShareMigration(),
  ]);
}
