
[![Build](https://github.com/michaelopes/simple_navigator/actions/workflows/build.yaml/badge.svg)](https://github.com/michaelopes/simple_navigator/actions/workflows/build.yaml) [![codecov](https://codecov.io/gh/michaelopes/simple_navigator/graph/badge.svg?token=7AS82WFNNW)](https://codecov.io/gh/michaelopes/simple_navigator)
[![pub](https://img.shields.io/pub/v/simple_navigator.svg?color=success)](https://pub.dev/packages/simple_navigator)

# SimpleNavigator - Flutter Package for Easy Named Route Navigation

SimpleNavigator is a lightweight Flutter package designed to simplify named route navigation within your Flutter application. With a focus on simplicity and ease of use, SimpleNavigator provides an alternative to more complex navigation solutions like go_router.

## Features
- **Easy-to-Use API:** Simplify your navigation code with a straightforward API.
- **Tabbed Navigation:** Seamlessly integrate tab-based navigation with SimpleNavigatorTabRoute.
- **Route Guards:** Add route guards to delay navigation or perform asynchronous tasks before navigating.
- **URL Strategy:** Enable URL strategy for cleaner and more user-friendly URLs.

## Getting Started
To get started with SimpleNavigator, follow these simple steps:

1. **Install the Package:**
   Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
    simple_navigator: ^1.0.0
```

2. **Import the Package:**
Import the package in your Dart file:

```dart
import 'package:simple_navigator/simple_navigator.dart';
```

3. **Set Up Routes:**
In your `main.dart` file, configure your routes using `SN.setRoutes`:

```dart
void main() {
  SN.setRoutes(
    // Add your routes configuration here
  );
  runApp(const MyApp());
}
```

4. **Implement MaterialApp:**
Use the `MaterialApp.router` widget in your `MyApp` class:


```dart
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
```

## Example Routes Configuration
Here's an example of how you can set up routes using SimpleNavigator:

```dart
 bool isUserLogged = false
 SN.setRoutes(
    urlStrategy: true,
    // Here, the reference to the splash page is added. 
    // Its behavior will be  explained in a dedicated topic.
    splash: (_) => SplashPage(),
    observers: [
      TestObs(),
    ],
    routes: [
      //Here, a root route with support for tabs is created.
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
      //Here, a non-root route with support for tabs is created.
      SimpleNavigatorTabRoute(
        path: "/tabs",
        builder: (_, child) => TabsPage(
          child: child,
        ),
        tabs: ["/main", "/settings", "/profile"],
        guard: (path) async {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          isUserLogged = prefs.getString('user-logged') != null;
          return isUserLogged ? path : "/login";
        },
      ),
      //Add a simple route
      SimpleNavigatorRoute(
        path: "/login",
        builder: (_) => const LoginPage(),
      ),
      //Here, a simple route with a guard is added. What is the guard? 
      //The guard is a feature that is executed before finalizing a route and can be 
      //used for security checks, as in the example below. However, any other 
      //type of execution can be performed within the guard. 
      //The route will only be finalized after all checks have been successfully processed.
      SimpleNavigatorRoute(
        path: "/feed",
        builder: (_) => const FeedPage(),
        guard: (path) async {
          return isUserLogged ? path : "/login";
        },
        //Loading to be displayed while the guard is not processed. 
        //If not informed, it will show the default loading of SimpleNavigator.
        guardLoadingBuilder: (context) => const Center(child: CircularProgressIndicator(),),
      ),
      SimpleNavigatorRoute(
        path: "/main",
        builder: (_) => const MainPage(),
        guard: (path) async {
          return isUserLogged ? path : "/login";
        },
      ),
      SimpleNavigatorRoute(
        path: "/settings",
        builder: (_) => const SettingsPage(),
        guard: (path) async {
          return isUserLogged ? path : "/login";
        },
      ),
      SimpleNavigatorRoute(
        path: "/profile",
        builder: (_) => const ProfilePage(),
        guard: (path) async {
          return isUserLogged ? path : "/login";
        },
      ),
      //Here, a route is added with path parameter passing, for example: :number.
      SimpleNavigatorRoute(
        path: "/sub/:number",
        builder: (_) => const SubPage(),
        guard: (path) async {
          return isUserLogged ? path : "/login";
        },
      )
    ],
  );
```

