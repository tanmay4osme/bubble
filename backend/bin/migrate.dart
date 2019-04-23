import 'package:backend/src/config/plugins/orm.dart';
import 'package:bubble/bubble.dart';
import 'package:angel_configuration/angel_configuration.dart';
import 'package:angel_migration_runner/angel_migration_runner.dart';
import 'package:angel_migration_runner/postgres.dart';
import 'package:file/local.dart';

main(List<String> args) async {
  var fs = LocalFileSystem();
  var configuration = await loadStandaloneConfiguration(fs);
  var connection = await connectToPostgres(configuration);
  var migrationRunner = PostgresMigrationRunner(connection, migrations: [
    UserMigration(),
    BubbleMigration(),
    BubbleAggregationRuleMigration(),
    PostMigration(),
    SubscriptionMigration(),
    PostShareMigration(),
  ]);
  return await runMigrations(migrationRunner, args);
}
