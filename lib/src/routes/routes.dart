library bubble.src.routes;

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_proxy/angel_proxy.dart';
import 'package:angel_static/angel_static.dart';
import 'package:file/file.dart';
import 'controllers/controllers.dart' as controllers;

AngelConfigurer configureServer(FileSystem fileSystem) {
  return (Angel app) async {
    // Typically, you want to mount controllers first, after any global middleware.
    await app.configure(controllers.configureServer);


    if (!app.environment.isProduction) {
      app.get('/routes', (req, res) {
        app.dumpTree(callback: res.writeln);
      });
    }

    if (!app.environment.isProduction) {
      var proxy = Proxy('http://localhost:8080', recoverFromDead: false);
      app
        ..fallback(proxy.handleRequest)
        ..fallback(proxy.pushState('index.html', accepts: ['text/html']));
    }

    if (!app.environment.isProduction) {
      var vDir = VirtualDirectory(
        app,
        fileSystem,
        source: fileSystem.directory('web'),
      );
      app.fallback(vDir.handleRequest);
    }

    // Throw a 404 if no route matched the request.
    app.fallback((req, res) => throw AngelHttpException.notFound());
  };
}
