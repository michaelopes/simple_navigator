library simple_navigator;

export 'src/simple_navigator_route.dart';
export 'src/simple_navigator_splash_completer_mixin.dart';

import 'package:flutter/material.dart';
import 'package:simple_navigator/src/simple_navigator_delegate.dart';
import 'package:simple_navigator/src/simple_navigator_parser.dart';
import 'package:simple_navigator/src/simple_navigator_route.dart';
import 'src/config/web_config.dart'
    if (dart.library.io) 'src/config/io_config.dart';

import 'src/simple_navigator_params.dart';

class SN {
  static late final SimpleNavigatorParams _params;
  static final navigatorKey = GlobalKey<NavigatorState>();
  static final parser = SimpleNavigatorParser();
  static SimpleNavigatorDelegate get delegate => to;

  static final to = SimpleNavigatorDelegate(
    params: _params,
    navigatorKey: navigatorKey,
  );

  static void setRoutes({
    required List<SimpleNavigatorRoute> routes,
    String initialRoute = "/",
    WidgetBuilder? splash,
    WidgetBuilder? notFound,
    bool urlStrategy = false,
  }) {
    if (urlStrategy) {
      configureUrlStrategy();
    }
    _params = SimpleNavigatorParams(
      notFound: notFound,
      splash: splash,
      routes: routes,
      initialRoute: initialRoute,
    );
  }
}
