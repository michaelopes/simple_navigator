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
  final List<Page> _availablePages = [];
  String _target = "";

  @override
  void initState() {
    SN.to.addListener(_listener);
    _load();
    super.initState();
  }

  void _load() {
    _availablePages.clear();
    for (var tab in widget.tabs) {
      final route = SN.to.getRouteByAbsolutePath(tab);
      if (route != null) {
        _availablePages.add(
          MaterialPage(
            name: "/tab$tab",
            restorationId: const Uuid().v4(),
            child: route.builder(context),
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
    final newTarget = SN.to.getQueryParameter("tab") as String?;
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
    _target = SN.to.getQueryParameter("tab");
    final targetName = "/tab/$_target";
    final page = _availablePages.firstWhereOrNull((e) => e.name == targetName);

    return SizedBox.expand(
      child: page == null
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
              pages: [
                page,
              ],
            ),
    );
  }
}

/*class SimpleNavigatorTabsWidget extends InheritedWidget {
  const SimpleNavigatorTabsWidget({
    Key? key,
    required this.tabs,
  }) : super(key: key);

  final List<String> tabs;


}*/

/*class SimpleNavigatorTabsWidget extends InheritedWidget {
  const SimpleNavigatorTabsWidget({
    super.key,
    required this.tabs,
    required super.child,
  });

  final List<String> tabs;

  /*static FrogColor? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FrogColor>();
  }*/

  /*static FrogColor of(BuildContext context) {
    final FrogColor? result = maybeOf(context);
    assert(result != null, 'No FrogColor found in context');
    return result!;
  }*/



  @override
  bool updateShouldNotify(SimpleNavigatorTabsWidget oldWidget) => tabs != oldWidget.tabs;
}*/
