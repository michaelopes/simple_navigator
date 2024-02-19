import 'package:flutter/material.dart';

import '../simple_navigator.dart';

class SimpleNavigatorTabsBuilder extends StatefulWidget {
  const SimpleNavigatorTabsBuilder({super.key, required this.builder});

  final WidgetBuilder builder;

  @override
  State<SimpleNavigatorTabsBuilder> createState() =>
      _SimpleNavigatorTabsBuilderState();
}

class _SimpleNavigatorTabsBuilderState
    extends State<SimpleNavigatorTabsBuilder> {
  String _target = "";
  String _routeReferenceId = "";

  @override
  void initState() {
    SN.to.addListener(_listener);
    _routeReferenceId = SN.to.lastRouteReferenceId ?? "";
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SimpleNavigatorTabsBuilder oldWidget) {
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
    if (_routeReferenceId != SN.to.lastRouteReferenceId) {
      return;
    }

    final newTarget = SN.to.currentTab;
    if (_target.isNotEmpty &&
        newTarget != null &&
        newTarget.isNotEmpty &&
        newTarget != _target) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    _target = SN.to.currentTab ?? "";
    return widget.builder(context);
  }
}
