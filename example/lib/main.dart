import 'package:example/feed_page.dart';
import 'package:example/home_page.dart';
import 'package:example/login_page.dart';
import 'package:example/main_page.dart';
import 'package:example/profile_page.dart';
import 'package:example/settings_page.dart';
import 'package:example/splash_page.dart';
import 'package:example/sub_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

void main() {
  SN.setRoutes(
    urlStrategy: true,
    splash: (_) => SplashPage(),
    observers: [
      TestObs(),
    ],
    routes: [
      SimpleNavigatorTabRoute(
        path: "/",
        builder: (_, child) => HomePage(
          child: child,
        ),
        tabs: ["/main", "/settings", "/profile"],
        guard: (path) async {
          await Future.delayed(const Duration(milliseconds: 2000));
          return path;
        },
      ),
      SimpleNavigatorRoute(
        path: "/login",
        builder: (_) => const LoginPage(),
        guard: (path) async {
          await Future.delayed(const Duration(milliseconds: 2000));
          return path;
        },
      ),
      SimpleNavigatorRoute(
        path: "/feed",
        builder: (_) => const FeedPage(),
      ),
      SimpleNavigatorRoute(
        path: "/main",
        builder: (_) => const MainPage(),
      ),
      SimpleNavigatorRoute(
        path: "/settings",
        builder: (_) => const SettingsPage(),
      ),
      SimpleNavigatorRoute(
        path: "/profile",
        builder: (_) => const ProfilePage(),
        guard: (path) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return path;
        },
      ),
      SimpleNavigatorRoute(
        path: "/sub/:number",
        builder: (_) => const SubPage(),
        guard: (path) async {
          await Future.delayed(const Duration(milliseconds: 50));
          return path;
        },
      )
    ],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

class TestObs extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    if (kDebugMode) {
      print("didPush ${route.settings.name}");
    }
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (kDebugMode) {
      print("didPop ${route.settings.name}");
    }
    super.didPush(route, previousRoute);
  }
}
