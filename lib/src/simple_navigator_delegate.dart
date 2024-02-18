import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_navigator/src/simple_navigator_utils.dart';

import 'simple_navigator_route.dart';
import 'simple_navigator_stack_handler.dart';

import 'simple_navigator_params.dart';

import 'simple_navigator_stack_widget.dart';

final class SimpleNavigatorDelegate extends RouterDelegate<Uri>
    with ChangeNotifier {
  late final GlobalKey<NavigatorState> _navigatorKey;
  late final SimpleNavigatorStackHandler _stackHandler;

  BuildContext? _context;

  SimpleNavigatorDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required SimpleNavigatorParams params,
  }) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();
    _stackHandler = SimpleNavigatorStackHandler(
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

  void tab(String tab, void Function(VoidCallback callback) setState) {
    final lastUri = _stackHandler.lastUri;
    if (lastUri != null) {
      setState(() {
        _stackHandler.setCurrentTab(lastUri.path, tab);
      });
    }
  }

  SimpleNavigatorRoute? getRouteByAbsolutePath(String path) {
    return _stackHandler.availableRoutes.firstWhereOrNull(
      (e) => path == e.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SimpleNavigatorStackWidget(
      navigatorKey: _navigatorKey,
      stackHandler: _stackHandler,
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
      final newUri = _stackHandler.initialUri
          .addQueryParameters(queryParameters: configuration.queryParameters);
      return super.setInitialRoutePath(newUri);
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
      final itemPath = !configuration.hasQuery
          ? configuration.path
          : configuration.toString();
      _stackHandler.loadInitialRoute(itemPath: itemPath);
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
