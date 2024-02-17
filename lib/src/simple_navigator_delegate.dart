import 'package:flutter/widgets.dart';

import 'simple_navigator_stack_handler.dart';

import 'simple_navigator_params.dart';

import 'simple_navigator_stack_widget.dart';

final class SimpleNavigatorDelegate extends RouterDelegate<Uri>
    with ChangeNotifier {
  late final GlobalKey<NavigatorState> _navigatorKey;
  late final SimpleNavigatoStackHandler _stackHandler;

  BuildContext? _context;

  SimpleNavigatorDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required SimpleNavigatorParams params,
  }) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    _stackHandler = SimpleNavigatoStackHandler(
      splash: params.splash,
      notFound: params.notFound,
      availableRoutes: params.routes,
      initialRoute: params.initialRoute,
      getContext: () => _context!,
      notifyListeners: () {
        notifyListeners();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SimpleNavigatorStackWidget(
      navigatorKey: _navigatorKey,
      pages: _stackHandler.pages,
      onPopPage: (route, result) {
        if (route.didPop(result)) {
          return _stackHandler.pop(result);
        }
        return false;
      },
    );
  }

  bool popUntil(
    String path, {
    Object? result,
    bool mostCloser = true,
  }) {
    final res = _stackHandler.popUntil(
      path,
      result: result,
      mostCloser: mostCloser,
    );
    return res;
  }

  bool pop([Object? result]) {
    final res = _stackHandler.pop(result);
    return res;
  }

  Future<dynamic> push(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> extras = const {},
  }) {
    final future = _stackHandler.push(
      path,
      queryParameters: queryParameters,
      extras: extras,
    );
    return future;
  }

  T? getQueryParameter<T>(String key) {
    final item = _stackHandler.lastStackItem;
    if (item != null) {
      return item.queryParameters[key] as T?;
    }
    return null;
  }

  T? getPathParameter<T>(String key) {
    final item = _stackHandler.lastStackItem;
    if (item != null) {
      return item.pathParameters[key] as T?;
    }
    return null;
  }

  T? getExtraParameter<T>(String key) {
    final item = _stackHandler.lastStackItem;
    if (item != null) {
      return item.pathParameters[key] as T?;
    }
    return null;
  }

  @override
  Future<bool> popRoute() async {
    return _stackHandler.pop();
  }

  @override
  Future<void> setInitialRoutePath(Uri configuration) {
    if (configuration.path == "/" ||
        configuration.path == _stackHandler.initialRoute) {
      return super.setInitialRoutePath(_stackHandler.initialUri);
    } else {
      return super.setInitialRoutePath(configuration);
    }
  }

  @override
  Future<void> setNewRoutePath(Uri configuration) async {
    final action = _stackHandler.detectAction(configuration);
    if (action == StackActionType.pop && _stackHandler.canPop()) {
      _stackHandler.pop();
    } else if (configuration.path != "/" &&
        configuration.path != _stackHandler.initialRoute) {
      _stackHandler.push(
        configuration.path,
        queryParameters: configuration.queryParameters,
      );
    } else if (configuration.path == _stackHandler.initialRoute &&
        !_stackHandler.hasItems) {
      _stackHandler.loadInitialRoute();
    }
  }

  @override
  Uri? get currentConfiguration {
    final lastUri = _stackHandler.lastUri;
    if (lastUri != null) {
      return lastUri;
    }
    return null;
  }
}
