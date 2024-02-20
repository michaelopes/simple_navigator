import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_navigator/simple_navigator.dart';
import 'package:simple_navigator/src/simple_navigator_dialog_handler.dart';
import 'package:simple_navigator/src/simple_navigator_params.dart';

import 'test_pages/feed_page.dart';
import 'test_pages/home_page.dart';
import 'test_pages/login_page.dart';
import 'test_pages/main_page.dart';
import 'test_pages/profile_page.dart';
import 'test_pages/settings_page.dart';
import 'test_pages/splash_page.dart';
import 'test_pages/sub_page.dart';
import 'test_pages/tabs_page.dart';

class MockBuildContext extends Mock implements BuildContext {}

class MockDialogHandler extends Mock implements SimpleNavigatorDialogHandler {}

String homeGuardResult = "/";

final List<SimpleNavigatorRoute> routes = [
  SimpleNavigatorTabRoute(
    path: "/",
    builder: (_, child) => HomePage(
      child: child,
    ),
    tabs: ["/main", "/settings", "/profile"],
    guard: (path) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      return homeGuardResult;
    },
  ),
  SimpleNavigatorTabRoute(
    path: "/tabs",
    builder: (_, child) => TabsPage(
      child: child,
    ),
    tabs: ["/main", "/settings", "/profile"],
    guard: (path) async {
      await Future.delayed(const Duration(milliseconds: 50));
      return path;
    },
  ),
  SimpleNavigatorRoute(
    path: "/login",
    builder: (_) => const LoginPage(),
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
];

final mockedBuildContext = MockBuildContext();

final testParams = SimpleNavigatorParams(
  routes: routes,
  initialRoute: "/",
  splash: (context) => SplashPage(),
  // ignore: avoid_unnecessary_containers
  notFound: (_) => Container(
    child: const Text("NOT FOUND"),
  ),
);
