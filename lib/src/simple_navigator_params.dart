import 'package:flutter/material.dart';
import 'simple_navigator_route.dart';

final class SimpleNavigatorParams {
  final List<SimpleNavigatorRoute> routes;
  final WidgetBuilder? splash;
  final WidgetBuilder? notFound;
  final String initialRoute;

  SimpleNavigatorParams({
    required this.routes,
    required this.initialRoute,
    this.splash,
    this.notFound,
  });
}
