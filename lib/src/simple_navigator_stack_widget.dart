import 'package:flutter/material.dart';

class SimpleNavigatorStackWidget extends StatefulWidget {
  const SimpleNavigatorStackWidget({
    Key? key,
    required this.pages,
    required this.navigatorKey,
    required this.onPopPage,
  }) : super(key: key);

  final List<Page> pages;
  final GlobalKey<NavigatorState> navigatorKey;
  final PopPageCallback? onPopPage;

  @override
  State<SimpleNavigatorStackWidget> createState() =>
      _SimpleNavigatorStackWidgetState();
}

class _SimpleNavigatorStackWidgetState
    extends State<SimpleNavigatorStackWidget> {
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
            pages: widget.pages,
            observers: const [],
            onPopPage: widget.onPopPage,
          );
  }
}
