library bubble.src.routes.controllers;

import 'dart:async';
import 'package:angel_framework/angel_framework.dart';
import 'bubble.dart';

Future configureServer(Angel app) async {
  /// Controllers will not function unless wired to the application!
  await app.mountController<BubbleController>();
}
