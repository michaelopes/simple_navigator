import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:simple_navigator/src/simple_navigator_utils.dart';

import 'simple_navigator_tabs_widget.dart';

class SimpleNavigatorRoute {
  final WidgetBuilder builder;
  final WidgetBuilder? guardLoadingBuilder;
  Future<String> Function()? guard;

  final String path;

  SimpleNavigatorRoute({
    required this.path,
    required this.builder,
    this.guardLoadingBuilder,
    RouteGuardFunc? guard,
  }) {
    Toolkit.assrt(
      () => Toolkit.isValidRoutePath(path),
      "Invalid path name '$path'",
    );
    if (guard != null) {
      this.guard = () => guard!(path);
    } else {
      guard = null;
    }
  }

  bool hasMatch(
    String finalPath, {
    bool prefix = false,
  }) {
    final regExp = pathToRegExp(!prefix ? path : finalPath, prefix: prefix);
    return regExp.hasMatch(!prefix ? finalPath : path);
  }

  Map<String, String> extractParams(String finalPath) {
    if (hasMatch(finalPath)) {
      final parameters = <String>[];
      final regExp = pathToRegExp(path, parameters: parameters);
      final match = regExp.matchAsPrefix(finalPath);
      if (match != null) {
        return extract(parameters, match);
      }
    }
    return {};
  }
}

typedef WidgetTabBuilder = Widget Function(BuildContext context, Widget child);
typedef SetCurrectTabFunc = void Function(String tab);

class SimpleNavigatorTabRoute extends SimpleNavigatorRoute {
  /// Tab path must be "/<tab-path>" as in the examples "/feed-tab\" or "/feed"
  final List<String> tabs;

  SimpleNavigatorTabRoute({
    required super.path,
    required WidgetTabBuilder builder,
    super.guardLoadingBuilder,
    this.tabs = const [],
    super.guard,
  }) : super(
          builder: (context) {
            return builder(
              context,
              SimpleNavigatorTabsWidget(
                tabs: tabs,
                path: path,
              ),
            );
          },
        ) {
    Toolkit.assrt(
      () => tabs.isEmpty || tabs.length > 1,
      "The list of tabs must be greater than or equal to 2.",
    );
    for (var tab in tabs) {
      Toolkit.assrt(
        () => tab.contains("/") && tab.split("/").length <= 2,
        "Tab path is invalid. Tab path must be '/<tab-path>' as in the examples '/feed-tab' or '/feed'",
      );
    }
  }
}
