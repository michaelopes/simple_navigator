import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_navigator/simple_navigator.dart';

import 'globals.dart';
import 'test_pages/splash_page.dart';

class Bootstrap {
  static Future<void> setup(
    WidgetTester tester, {
    List<NavigatorObserver> observers = const [],
  }) async {
    SN.setRoutes(
      urlStrategy: true,
      splash: (_) => SplashPage(),
      notFound: (_) => const Text("NOT FOUND"),
      observers: observers,
      routes: routes,
    );
    SN.reloadForTest();
    const widget = _MyApp();
    await tester.pumpWidget(widget);
  }
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: Theme.of(context).copyWith(
        scaffoldBackgroundColor: Colors.amber,
      ),
      routerDelegate: SN.delegate,
      routeInformationParser: SN.parser,
    );
  }
}
