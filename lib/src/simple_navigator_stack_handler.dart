import 'dart:async';
import 'dart:core';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:queue/queue.dart';
import 'package:simple_navigator/src/simple_navigator_dialog_handler.dart';
import 'package:uuid/uuid.dart';

import 'simple_navigator_route.dart';
import 'simple_navigator_splash_completer_mixin.dart';
import 'simple_navigator_utils.dart';

enum StackActionType { push, pop }

class SimpleNavigatoStackItem {
  final SimpleNavigatorRoute route;
  late final Uri _uri;
  late final Completer<dynamic> resultCompleter;
  late bool _allowBuild;
  late final Map<String, dynamic> _extras;
  late final String referenceId;
  Page? _page;
  String currentTab = "";

  SimpleNavigatoStackItem({
    required this.route,
    required String itemPath,
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> extras = const {},
  }) {
    _allowBuild = true;
    _extras = extras;
    var queryString = Uri(queryParameters: queryParameters).query;
    if (queryString.isNotEmpty) {
      itemPath += (itemPath.contains("?") ? "&" : "?") + queryString;
    }

    if (route is SimpleNavigatorTabRoute) {
      final rt = route as SimpleNavigatorTabRoute;
      if (rt.tabs.isNotEmpty) {
        currentTab = rt.tabs.first;
      }
    }

    _uri = Uri.parse(itemPath);
    if (_uri.queryParameters["tab"] != null &&
        _uri.queryParameters["tab"]!.isNotEmpty) {
      currentTab = _uri.queryParameters["tab"]!;
    }
    resultCompleter = Completer();
    referenceId = const Uuid().v4();
  }

  Uri get uri {
    if (currentTab.isNotEmpty) {
      return _uri.mergeQueryParameters(
        queryParameters: {
          "tab": currentTab.replaceAll("/", ""),
        },
      );
    } else {
      return _uri;
    }
  }

  bool get hasPage => !_allowBuild;

  Map<String, String> get pathParameters =>
      Map.unmodifiable(route.extractParams(uri.path));

  Map<String, String> get queryParameters =>
      Map.unmodifiable(uri.queryParameters);

  Map<String, dynamic> get extras => Map.unmodifiable(_extras);

  Page page(BuildContext context) {
    if (_allowBuild) {
      _page = MaterialPage(
        child: route.builder(context),
        name: uri.path,
        maintainState: true, //route is SimpleNavigatorTabRoute ? false : true,
        key: ValueKey("$referenceId${uri.toString()}"),
        restorationId: const Uuid().v4(),
        arguments: {
          "pathParameters": pathParameters,
          "queryParameters": queryParameters,
          "extras": extras,
        },
      );
    }
    _allowBuild = false;
    return _page!;
  }
}

class SimpleNavigatoStackLoadingItem extends SimpleNavigatoStackItem {
  SimpleNavigatoStackLoadingItem({
    WidgetBuilder? guardLoadingBuilder,
  }) : super(
          itemPath: "/page-guard-loading",
          route: SimpleNavigatorRoute(
            path: "/page-guard-loading",
            builder: (context) =>
                guardLoadingBuilder?.call(context) ??
                Material(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: const SizedBox.expand(
                    child: Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                ),
          ),
        );
}

class SimpleNavigatorStackHandler {
  late final SimpleNavigatorDialogHandler _dialogHandler;
  final List<SimpleNavigatorRoute> availableRoutes;
  final String initialRoute;
  final WidgetBuilder? notFound;
  final WidgetBuilder? splash;

  final List<SimpleNavigatoStackItem> _stack = [];
  final BuildContext Function() getContext;
  final VoidCallback notifyListeners;
  final _queue = Queue();

  SimpleNavigatorStackHandler({
    required this.availableRoutes,
    required this.getContext,
    required this.notifyListeners,
    required SimpleNavigatorDialogHandler dialogHandler,
    this.initialRoute = "/",
    this.notFound,
    this.splash,
  }) {
    _dialogHandler = dialogHandler;
    if (!availableRoutes.any((e) => e.hasMatch(initialRoute))) {
      throw Exception("Initial route \"$initialRoute\" has not found.");
    }
  }

  void loadInitialRoute({String itemPath = ""}) {
    if (itemPath.isEmpty) {
      itemPath = initialRoute;
    }
    final item = SimpleNavigatoStackItem(
      itemPath: itemPath,
      route: _getItemByPath(initialRoute),
    );
    _queue.add(
      () => _processPush(
        initialRoute,
        item,
        isInitial: true,
      ),
    );
  }

  bool setCurrentTab(String routePath, tabPath) {
    final item = _stack.lastWhereOrNull((r) => r.route.path == routePath);
    if (item != null) {
      if (item.currentTab != tabPath) {
        item.currentTab = tabPath;
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  SimpleNavigatorRoute _getItemByPath(String path) {
    final r = availableRoutes.firstWhereOrNull(
      (e) => e.hasMatch(path),
    );
    if (r != null) {
      return r;
    } else {
      return SimpleNavigatorRoute(
        builder: (context) =>
            notFound?.call(context) ??
            const Material(
              color: Colors.red,
              child: SizedBox.expand(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "404 Page Not Found!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        path: path,
      );
    }
  }

  Future<dynamic> push(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> extras = const {},
  }) {
    final route = _getItemByPath(path);
    final item = SimpleNavigatoStackItem(
      itemPath: path,
      queryParameters: queryParameters,
      extras: extras,
      route: route,
    );
    _queue.add(() async => _processPush(path, item));
    return item.resultCompleter.future;
  }

  Future<dynamic> replaceCurrent(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> extras = const {},
  }) async {
    if (Toolkit.hasPathsMatch(initialRoute, path)) {
      return;
    }

    if (lastRouteReferenceId != null) {
      _dialogHandler.popAll(lastRouteReferenceId!);
    }

    final route = _getItemByPath(path);
    final item = SimpleNavigatoStackItem(
      itemPath: path,
      queryParameters: queryParameters,
      extras: extras,
      route: route,
    );

    _queue.add(() async => _processPush(path, item, replaceOrigin: true));
    return item.resultCompleter.future;
  }

  Future<void> _processPush(
    String path,
    SimpleNavigatoStackItem item, {
    bool isInitial = false,
    bool replaceOrigin = false,
  }) async {
    if (isInitial) {
      _stack.clear();
    }

    if (!item.hasPage && item.route.guard != null) {
      Widget? wSplash;
      _stack.add(
        SimpleNavigatoStackLoadingItem(
          guardLoadingBuilder: isInitial && splash != null
              ? (_) {
                  wSplash = splash!(getContext());
                  return wSplash!;
                }
              : item.route.guardLoadingBuilder,
        ),
      );
      if (!isInitial) {
        _notifyWithNeglect();
      }
      final gRes = await item.route.guard!();
      if (wSplash != null && wSplash is SimpleNavigatorSplashCompleterMixin) {
        await (wSplash as SimpleNavigatorSplashCompleterMixin).wait;
      }
      if (!item.route.hasMatch(gRes) && gRes != initialRoute) {
        _stack.clear();
        _stack.add(
          SimpleNavigatoStackItem(
            itemPath: gRes,
            route: _getItemByPath(gRes),
          ),
        );
      } else {
        if (replaceOrigin) {
          _stack.removeLast();
        }
        if (_stack.isNotEmpty) {
          _stack.removeLast();
        }
        _stack.add(item);
      }
    } else {
      if (_stack.isEmpty && replaceOrigin) {
        _stack.removeLast();
      }
      _stack.add(item);
    }
    if (replaceOrigin || isInitial) {
      _notifyWithNeglect();
    } else {
      notifyListeners();
    }
  }

  void _notifyWithNeglect() {
    try {
      final ctx = getContext();
      if (Router.maybeOf(ctx) != null) {
        Router.neglect(ctx, () {
          notifyListeners();
        });
      } else {
        notifyListeners();
      }
    } on NullableBuildContext {
      notifyListeners();
    }
  }

  bool canPop() {
    return _stack.length > 1 || canPopTab();
  }

  bool canPopTab() {
    var item = _stack.last;
    final route = item.route;
    if (route is SimpleNavigatorTabRoute &&
        _stack.last.currentTab != route.tabs.first) {
      return true;
    }
    return false;
  }

  bool pop([Object? result]) {
    var item = _stack.last;
    bool response = _dialogHandler.pop(item.referenceId, result);
    if (!response) {
      if (canPopTab()) {
        final route = item.route;
        if (route is SimpleNavigatorTabRoute &&
            _stack.last.currentTab != route.tabs.first) {
          _stack.last.currentTab = route.tabs.first;
          notifyListeners();
          return true;
        }
      }
      if (canPop()) {
        _stack.removeLast();
        item.resultCompleter.complete(result);
        response = true;
        notifyListeners();
      }
    }
    return response;
  }

  bool popUntil(
    String path, {
    Object? result,
    bool mostCloser = true,
  }) {
    if (canPop()) {
      final items = _stack
          .where(
            (e) =>
                e.route.hasMatch(path, prefix: true) &&
                (Toolkit.hasPathsMatch(path, initialRoute)
                    ? true
                    : Toolkit.hasPathsMatch(e.route.path, initialRoute)
                        ? false
                        : true),
          )
          .toList();
      if (items.isNotEmpty) {
        final item = mostCloser ? items.last : items.first;
        var index = _stack.indexOf(item) + 1;
        if (path == initialRoute) {
          index = 1;
        }
        if (index > 0) {
          if (index >= 0 && index < _stack.length) {
            final rItems = _stack.getRange(index, _stack.length).toList();
            for (var rItem in rItems) {
              rItem.resultCompleter.complete(
                rItem == rItems.first ? result : null,
              );
              _dialogHandler.popAll(rItem.referenceId);
              _stack.remove(rItem);
            }
            notifyListeners();
            return true;
          }
        }
      } else if (kIsWeb) {
        pop(result);
      }
    }
    return false;
  }

  StackActionType detectAction(Uri uri) {
    if (_stack.isNotEmpty && canPopTab()) {
      return StackActionType.pop;
    }
    final filter = _stack.where((e) {
      return e.uri.toString() == uri.toString();
    });

    if (filter.isNotEmpty) {
      final index = _stack.indexOf(filter.last);
      if ((_stack.length - 1) >= index) {
        return StackActionType.pop;
      }
    }

    return StackActionType.push;
  }

  SimpleNavigatoStackItem? get lastStackItem =>
      _stack.isEmpty ? null : _stack.last;

  bool get hasItems => _stack.isNotEmpty;

  String? get lastRouteReferenceId => _stack.isEmpty
      ? null
      : _stack.last is! SimpleNavigatoStackLoadingItem
          ? _stack.last.referenceId
          : null;

  Uri? get lastUri => _stack.isEmpty
      ? null
      : _stack.last is! SimpleNavigatoStackLoadingItem
          ? _stack.last.uri
          : null;

  Uri get initialUri => _stack.isEmpty
      ? Uri.parse(initialRoute)
      : _stack.first is! SimpleNavigatoStackLoadingItem
          ? _stack.first.uri
          : Uri.parse(initialRoute);

  int get stackLength => _stack.length;

  List<Page> get pages => List.unmodifiable(
        _stack.map((e) => e.page(getContext())).toList(),
      );
}
