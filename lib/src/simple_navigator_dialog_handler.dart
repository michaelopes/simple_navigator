import 'package:flutter/material.dart';

class _SimpleNavigatorDialogItem {
  final String routeReferenceId;
  final int index;

  _SimpleNavigatorDialogItem(this.routeReferenceId, this.index);
}

class SimpleNavigatorDialogHandler extends NavigatorObserver {
  NavigatorState? _customNavigator;
  SimpleNavigatorDialogHandler({
    required this.getRouteReferenceId,
    NavigatorState? customNavigator,
  }) {
    _customNavigator = customNavigator;
  }

  final String? Function() getRouteReferenceId;
  final _storage = <_SimpleNavigatorDialogItem>[];

  @override
  NavigatorState? get navigator => _customNavigator ?? super.navigator;

  @override
  void didPush(Route route, Route? previousRoute) {
    final referenceId = getRouteReferenceId();
    if (route is DialogRoute && referenceId != null) {
      final index = _storage.length;
      _storage.add(
        _SimpleNavigatorDialogItem(
          referenceId,
          index,
        ),
      );
    }
    super.didPush(route, previousRoute);
  }

  void popAll(String referenceId) {
    final filter =
        _storage.where((e) => e.routeReferenceId == referenceId).toList();
    for (var item in filter) {
      _storage.remove(item);
      navigator!.pop();
    }
  }

  bool pop(String referenceId, Object? result) {
    final filter =
        _storage.where((e) => e.routeReferenceId == referenceId).toList();
    if (filter.isNotEmpty && navigator != null && navigator!.canPop()) {
      filter.sort((a, b) => a.index.compareTo(b.index));
      _storage.remove(filter.last);
      navigator!.pop(result);
      return true;
    }
    return false;
  }
}
