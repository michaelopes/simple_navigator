import 'package:example/feed_page.dart';
import 'package:example/home_page.dart';
import 'package:example/login_page.dart';
import 'package:example/splash_page.dart';
import 'package:example/sub_page.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

void main() {
  SN.setRoutes(
    urlStrategy: true,
    splash: (_) => SplashPage(),
    initialRoute: "/login",
    routes: [
      SimpleNavigatorRoute(
        path: "/",
        builder: (_) => const HomePage(),
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
