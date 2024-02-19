import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:simple_navigator/src/simple_navigator_dialog_handler.dart';
import 'package:simple_navigator/src/simple_navigator_utils.dart';

import 'simple_navigator_route.dart';
import 'simple_navigator_stack_handler.dart';

import 'simple_navigator_params.dart';

import 'simple_navigator_stack_widget.dart';

final class SimpleNavigatorDelegate extends RouterDelegate<Uri>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin
    implements ISimpleNavigator {
  late final GlobalKey<NavigatorState> _navigatorKey;
  late final SimpleNavigatorStackHandler _stackHandler;
  late final List<NavigatorObserver> observers;

  BuildContext? _context;

  SimpleNavigatorDelegate({
    required SimpleNavigatorParams params,
    GlobalKey<NavigatorState>? navigatorKey,
  }) {
    _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

    final dialogHandler = SimpleNavigatorDialogHandler(
      getRouteReferenceId: () => lastRouteReferenceId,
    );

    _stackHandler = SimpleNavigatorStackHandler(
      splash: params.splash,
      notFound: params.notFound,
      availableRoutes: params.routes,
      initialRoute: params.initialRoute,
      dialogHandler: dialogHandler,
      getContext: () => _context!,
      notifyListeners: () {
        notifyListeners();
      },
    );

    observers = [dialogHandler, ...params.observers];
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return SimpleNavigatorStackWidget(
      deletate: this,
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

  @override
  void tab(String tab, State ownerState) {
    final lastUri = _stackHandler.lastUri;
    if (lastUri != null) {
      if (_stackHandler.setCurrentTab(lastUri.path, tab)) {
        (ownerState.context as Element).markNeedsBuild();
      }
    }
  }

  @override
  SimpleNavigatorRoute? getRouteByAbsolutePath(String path) {
    return _stackHandler.availableRoutes.firstWhereOrNull(
      (e) => path == e.path,
    );
  }

  @override
  Future<bool> popUntil(
    String path, {
    Object? result,
    bool mostCloser = true,
  }) async {
    var res = _stackHandler.popUntil(
      path,
      result: result,
      mostCloser: mostCloser,
    );

    return res;
  }

  @override
  Future<bool> pop([Object? result]) async {
    final res = _stackHandler.pop(result);
    return res;
  }

  @override
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

  @override
  T? getQueryParameter<T>(String key) {
    final item = _stackHandler.lastStackItem;
    if (item != null) {
      return item.queryParameters[key] as T?;
    }
    return null;
  }

  @override
  T? getPathParameter<T>(String key) {
    final item = _stackHandler.lastStackItem;
    if (item != null) {
      return item.pathParameters[key] as T?;
    }
    return null;
  }

  @override
  T? getExtraParameter<T>(String key) {
    final item = _stackHandler.lastStackItem;
    if (item != null) {
      return item.pathParameters[key] as T?;
    }
    return null;
  }

  /* @override
  Future<bool> popRoute() async {
    return _stackHandler.pop();
  }*/

  @override
  Future<void> setInitialRoutePath(Uri configuration) {
    if (configuration.path == "/" ||
        configuration.path == _stackHandler.initialRoute) {
      final newUri = _stackHandler.initialUri
          .mergeQueryParameters(queryParameters: configuration.queryParameters);
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

  String? get lastRouteReferenceId => _stackHandler.lastRouteReferenceId;

  @override
  Uri? get currentConfiguration {
    final lastUri = _stackHandler.lastUri;
    if (lastUri != null) {
      return lastUri;
    }
    return null;
  }

  @override
  String? get currentTab => "/${getQueryParameter("tab")}";

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
}
