import 'dart:io';
import 'package:bubble/bubble.dart';
import 'package:angel_container/mirrors.dart';
import 'package:angel_framework/angel_framework.dart';
import 'package:angel_hot/angel_hot.dart';
import 'package:glob/glob.dart';
import 'package:logging/logging.dart';
import 'package:pretty_logging/pretty_logging.dart';

main() async {
  // Watch the config/ and web/ directories for changes, and hot-reload the server.
  hierarchicalLoggingEnabled = true;
  var hot = HotReloader(() async {
    var logger = Logger.detached('bubble')
      ..level = Level.ALL
      ..onRecord.listen(prettyLog);
    var app = Angel(logger: logger, reflector: MirrorsReflector());
    await app.configure(configureServer);
    return app;
  }, [
    Directory('config'),
    Directory('lib/src/config'),
    Directory('lib/src/routes'),
    Directory('lib/src/services'),
    Glob('lib/*.dart'),
  ]);

  var server = await hot.startServer('127.0.0.1', 3000);
  print(
      'bubble server listening at http://${server.address.address}:${server.port}');
}
