import 'package:flutter/material.dart';
import 'package:path_to_regexp/path_to_regexp.dart';
import 'package:simple_navigator/src/simple_navigator_utils.dart';

class SimpleNavigatorRoute {
  final WidgetBuilder builder;
  final List<SimpleNavigatorRoute> tabs;

  final WidgetBuilder? guardLoadingBuilder;
  Future<String> Function()? guard;

  late final Uri _uri;

  SimpleNavigatorRoute({
    required String path,
    required this.builder,
    this.guardLoadingBuilder,
    this.tabs = const [],
    RouteGuardFunc? guard,
  }) {
    _uri = Uri.parse(path);
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
    final parameters = <String>[];
    final regExp = pathToRegExp(path, parameters: parameters);
    final match = regExp.matchAsPrefix(finalPath);
    if (match != null) {
      return extract(parameters, match);
    }
    return {};
  }

  String get path => _uri.path;
}
