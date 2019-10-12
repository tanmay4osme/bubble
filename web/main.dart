import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bubble/src/ng/components/bubble_app.template.dart' as ng;
import 'main.template.dart' as ng;

@GenerateInjector([
  routerProviders,
  ClassProvider(LocationStrategy, useClass: HashLocationStrategy),
])
final InjectorFactory bubbleInjector = ng.bubbleInjector$Injector;

void main() {
  runApp(ng.BubbleAppComponentNgFactory, createInjector: bubbleInjector);
}
