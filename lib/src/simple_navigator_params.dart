import 'package:flutter/material.dart';
import 'simple_navigator_route.dart';

class SimpleNavigatorParams {
  final List<SimpleNavigatorRoute> routes;
  final WidgetBuilder? splash;
  final WidgetBuilder? notFound;
  final String initialRoute;
  final List<NavigatorObserver> observers;

  SimpleNavigatorParams({
    required this.routes,
    required this.initialRoute,
    this.observers = const [],
    this.splash,
    this.notFound,
  });
}
