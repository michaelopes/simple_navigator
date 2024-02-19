import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

import 'simple_navigator_route.dart';

typedef RouterBuilderFunc = Widget Function();
typedef RouteGuardFunc = Future<String> Function(String path);

class Toolkit {
  static bool hasPathsMatch(String routePath, String itemPath) {
    final regExp = pathToRegExp(routePath);
    return regExp.hasMatch(itemPath);
  }

  static void printRedText(String text) {
    // ANSI escape code for red text
    const String redColorCode = '\x1B[31m';
    // ANSI escape code to reset text color
    const String resetColorCode = '\x1B[0m';
    if (kDebugMode) {
      print('$redColorCode$text$resetColorCode');
    }
  }

  static void asset(bool Function() condition, String text) {
    if (!condition()) {
      printRedText(text);
    }
    assert(condition(), text);
  }
}

extension UriExt on Uri {
  Uri mergeQueryParameters({
    required Map<String, String> queryParameters,
  }) {
    final uri = Uri(
      path: path,
      queryParameters: {
        ...this.queryParameters,
        ...queryParameters,
      },
    );
    return uri;
  }
}

abstract class ISimpleNavigator {
  void tab(String tab, State ownerState);
  SimpleNavigatorRoute? getRouteByAbsolutePath(String path);
  Future<bool> popUntil(
    String path, {
    Object? result,
    bool mostCloser = true,
  });
  Future<bool> pop([Object? result]);
  Future<dynamic> push(
    String path, {
    Map<String, String> queryParameters = const {},
    Map<String, dynamic> extras = const {},
  });
  T? getQueryParameter<T>(String key);
  T? getPathParameter<T>(String key);
  T? getExtraParameter<T>(String key);

  String? get currentTab;
}
