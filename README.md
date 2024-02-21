
[![Build](https://github.com/michaelopes/simple_navigator/actions/workflows/build.yaml/badge.svg)](https://github.com/michaelopes/simple_navigator/actions/workflows/build.yaml) [![codecov](https://codecov.io/gh/michaelopes/simple_navigator/graph/badge.svg?token=7AS82WFNNW)](https://codecov.io/gh/michaelopes/simple_navigator)
[![pub](https://img.shields.io/pub/v/simple_navigator.svg?color=success)](https://pub.dev/packages/simple_navigator)

# SimpleNavigator - Flutter Package for Easy Named Route Navigation

SimpleNavigator is a lightweight Flutter package designed to simplify named route navigation within your Flutter application. With a focus on simplicity and ease of use, SimpleNavigator offers an alternative to more complex navigation solutions as proposed by the go_router package.

## Features
- **Easy-to-Use API:** Simplify your navigation code with a straightforward API.
- **Tabbed Navigation:** Seamlessly integrate tab-based navigation with SimpleNavigatorTabRoute.
- **Route Guards:** Add route guards to checking before navigation or perform asynchronous tasks before navigating.
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
      //Here is a example a non-root route with support for tabs is created.
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
## Splash Screen
The purpose of the splash screen is to appear during the app's initialization before processing the guard of the root route. If you need the splash to stay on the screen longer, it can be added to an inheritance of the SimpleNavigatorSplashCompleterMixin mixin. When you want the splash to close, call widget.complete();, and it will close, showing the previously configured root route.

Obs: guardLoadingBuilder is ignored when splash is informed in `SN.setRoutes` for initialRoute (root route) on example above is "/"

### SplashPage Widget example

```dart
class SplashPage extends StatefulWidget with SimpleNavigatorSplashCompleterMixin {
  SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    //The next page will called with complete executed
    //Is a fake delay for simulate a process tasks before 
    //Complete to show page configured as root
    Future.delayed(const Duration(seconds: 1), () {
      widget.complete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: const Text("SPLASH"),
        ),
      ),
    );
  }
}
```


## Resources

### Navigating to Another Screen

To navigate to another screen using SimpleNavigator, use the following syntax:

```dart
final result = await SN.to.push("/<route name>", /* additional parameters */);
```
Replace <route name> with the actual name of the route you want to navigate to. 
The SN.to.push method returns a result that can be utilized if there's a need 
to retrieve values when the subsequent route is closed.

### Closing a Screen
To close the current screen within SimpleNavigator, use the following syntax:

```dart
SN.to.pop();
```

### Returning a Value to the Previous Screen
If you want to return a value to the previous screen, use the following syntax:

```dart
SN.to.pop(/* value to be returned */);
```

### Closing Screens Until a Specific Route
To close multiple screens until reaching a specific route, use the following syntax:

```dart
SN.to.popUntil("/<route name>", /* value to be returned (optional) */);
```
### Tab Navigation
```dart
final result = await SN.to.tab("/<tab name>");
```

## Tab page example

```dart
class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (kDebugMode) {
      print("_HomePageState");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //This builder "SimpleNavigatorTabsBuilder"
    //is important to change state tab navigation controll
    return SimpleNavigatorTabsBuilder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.purple,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              )
            ],
            currentIndex: () {
              if (SN.to.currentTab == "/main") {
                return 0;
              } else if (SN.to.currentTab == "/settings") {
                return 1;
              }
              return 2;
            }(),
            onTap: (index) {
              if (index == 2) {
                SN.to.tab("/profile");
              } else if (index == 1) {
                SN.to.tab("/settings");
              } else {
                SN.to.tab("/main");
              }
            },
          ),
          body: widget.child,
        );
      },
    );
  }
}

```

