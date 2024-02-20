library simple_navigator;

export 'src/simple_navigator_route.dart';
export 'src/simple_navigator_tabs_builder.dart';
export 'src/simple_navigator_splash_completer_mixin.dart';

import 'package:flutter/material.dart';
import 'package:simple_navigator/src/simple_navigator_delegate.dart';
import 'package:simple_navigator/src/simple_navigator_parser.dart';
import 'package:simple_navigator/src/simple_navigator_route.dart';
import 'src/config/web_config.dart'
    if (dart.library.io) 'src/config/io_config.dart';

import 'src/simple_navigator_params.dart';
import 'src/simple_navigator_stack_widget.dart';

class SN {
  static late SimpleNavigatorParams _params;
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final parser = SimpleNavigatorParser();
  static SimpleNavigatorDelegate get delegate => to;

  static SimpleNavigatorDelegate to = SimpleNavigatorDelegate(
    params: _params,
    navigatorKey: navigatorKey,
  );

  static void setRoutes({
    required List<SimpleNavigatorRoute> routes,
    String initialRoute = "/",
    WidgetBuilder? splash,
    WidgetBuilder? notFound,
    bool urlStrategy = false,
    List<NavigatorObserver> observers = const [],
  }) {
    if (urlStrategy) {
      configureUrlStrategy();
    }
    _params = SimpleNavigatorParams(
      notFound: notFound,
      splash: splash,
      routes: routes,
      initialRoute: initialRoute,
      observers: observers,
    );
  }

  @visibleForTesting
  static void reloadForTest() {
    to = SimpleNavigatorDelegate(
      params: _params,
      navigatorKey: navigatorKey,
    );
  }

  static SimpleNavigatorStackWidgetState of(BuildContext context) {
    return context
        .findRootAncestorStateOfType<SimpleNavigatorStackWidgetState>()!;
  }
}
