import 'package:flutter/material.dart';
import 'package:simple_navigator/src/simple_navigator_route.dart';
import 'simple_navigator_delegate.dart';
import 'simple_navigator_utils.dart';

class SimpleNavigatorStackWidget extends StatefulWidget {
  const SimpleNavigatorStackWidget({
    Key? key,
    required this.pages,
    required this.navigatorKey,
    required this.deletate,
    required this.onPopPage,
  }) : super(key: key);

  final List<Page> pages;
  final GlobalKey<NavigatorState> navigatorKey;
  final PopPageCallback? onPopPage;
  final SimpleNavigatorDelegate deletate;

  @override
  State<SimpleNavigatorStackWidget> createState() =>
      SimpleNavigatorStackWidgetState();
}

typedef StackWidgetStateListener = void Function();

class SimpleNavigatorStackWidgetState extends State<SimpleNavigatorStackWidget>
    implements ISimpleNavigator {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.pages.isEmpty
        ? const SizedBox.shrink()
        : Navigator(
            restorationScopeId: "root",
            key: widget.navigatorKey,
            observers: widget.deletate.observers,
            pages: widget.pages,
            onPopPage: widget.onPopPage,
          );
  }

  @override
  T? getExtraParameter<T>(String key) =>
      widget.deletate.getExtraParameter<T>(key);

  @override
  T? getPathParameter<T>(String key) =>
      widget.deletate.getPathParameter<T>(key);

  @override
  T? getQueryParameter<T>(String key) =>
      widget.deletate.getQueryParameter<T>(key);

  @override
  SimpleNavigatorRoute? getRouteByAbsolutePath(String path) =>
      widget.deletate.getRouteByAbsolutePath(path);

  @override
  Future<bool> pop([Object? result]) => widget.deletate.pop(result);

  @override
  Future<bool> popUntil(String path,
          {Object? result, bool mostCloser = true}) =>
      widget.deletate.popUntil(path, result: result, mostCloser: mostCloser);

  @override
  Future push(String path,
          {Map<String, String> queryParameters = const {},
          Map<String, dynamic> extras = const {}}) =>
      widget.deletate.push(
        path,
        queryParameters: queryParameters,
        extras: extras,
      );

  @override
  void tab(String tab) => widget.deletate.tab(tab);

  @override
  String? get currentTab => widget.deletate.currentTab;
}
