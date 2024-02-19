import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';
import 'package:uuid/uuid.dart';

class SimpleNavigatorTabsWidget extends StatefulWidget {
  const SimpleNavigatorTabsWidget({
    Key? key,
    required this.tabs,
    required this.path,
  }) : super(key: key);
  final List<String> tabs;
  final String path;

  @override
  State<SimpleNavigatorTabsWidget> createState() =>
      _SimpleNavigatorTabsWidgetState();
}

class _SimpleNavigatorTabsWidgetState extends State<SimpleNavigatorTabsWidget> {
  final _availableItems = <_TabItem>[];
  final _pushedItems = <_TabItem>[];
  String _target = "";

  @override
  void initState() {
    SN.to.addListener(_listener);
    _load();
    super.initState();
  }

  void _load() {
    _availableItems.clear();
    for (var tab in widget.tabs) {
      final route = SN.to.getRouteByAbsolutePath(tab);
      if (route != null) {
        _availableItems.add(
          _TabItem(
            isFirst: tab == widget.tabs.first,
            page: _TabPage(
              name: "/tab$tab",
              restorationId: const Uuid().v4(),
              child: route.builder(context),
            ),
            name: "/tab$tab",
          ),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant SimpleNavigatorTabsWidget oldWidget) {
    if (widget.hashCode != oldWidget.hashCode) {
      SN.to.removeListener(_listener);
      SN.to.addListener(_listener);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    SN.to.removeListener(_listener);
    super.dispose();
  }

  void _listener() {
    final newTarget = SN.to.currentTab;
    if (_target.isNotEmpty &&
        newTarget != null &&
        newTarget.isNotEmpty &&
        newTarget != _target &&
        SN.to.currentConfiguration?.path == widget.path) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _target = SN.to.currentTab ?? "";
    final targetName = "/tab$_target";
    final item = _availableItems.firstWhereOrNull(
      (e) => _target.isNotEmpty && e.name == targetName,
    );
    if (item != null) {
      if (item.isFirst && _pushedItems.any((e) => e.isFirst)) {
        _pushedItems.removeLast();
      } else if (item.isFirst && !_pushedItems.any((e) => e.isFirst)) {
        _pushedItems.clear();
        _pushedItems.add(item);
      } else if (!item.isFirst) {
        if (_pushedItems.length > 1) {
          _pushedItems.removeLast();
        }
        _pushedItems.add(item);
      }
    }

    return SizedBox.expand(
      child: item == null
          ? const Material(
              color: Colors.red,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "404 Tab Not Found!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            )
          : Navigator(
              onPopPage: (route, result) {
                return false;
              },
              pages: _pushedItems.map((e) => e.page).toList(),
            ),
    );
  }
}

class _TabItem {
  final Page page;
  final String name;
  final bool isFirst;
  _TabItem({required this.name, required this.page, required this.isFirst});
}

class _TabPage<T> extends MaterialPage<T> {
  const _TabPage({
    required super.child,
    super.maintainState = true,
    super.fullscreenDialog = false,
    super.allowSnapshotting = true,
    super.key,
    super.name,
    super.arguments,
    super.restorationId,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    return _TabPageRoute<T>(page: this, allowSnapshotting: allowSnapshotting);
  }
}

class _TabPageRoute<T> extends PageRoute<T> {
  _TabPageRoute({
    required MaterialPage<T> page,
    super.allowSnapshotting,
  }) : super(settings: page);

  MaterialPage<T> get _page => settings as MaterialPage<T>;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: _page.child,
    );
  }

  @override
  bool get fullscreenDialog => _page.fullscreenDialog;

  @override
  String get debugLabel => '${super.debugLabel}(${_page.name})';

  @override
  bool get maintainState => _page.maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 350);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;
}
