import 'package:angel_migration_runner/angel_migration_runner.dart';
import 'package:bubble/migration.dart';

main(List<String> args) async {
  var migrationRunner = await createMigrationRunner();
  return await runMigrations(migrationRunner, args);
}
