import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';

typedef RouterBuilderFunc = Widget Function();
typedef RouteGuardFunc = Future<String> Function(String path);

class Toolkit {
  static bool hasPathsMatch(String routePath, String itemPath) {
    final regExp = pathToRegExp(routePath);
    return regExp.hasMatch(itemPath);
  }
}
