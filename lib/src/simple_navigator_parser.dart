import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

final class SimpleNavigatorParser extends RouteInformationParser<Uri> {
  @override
  Future<Uri> parseRouteInformation(RouteInformation routeInformation) =>
      SynchronousFuture(routeInformation.uri);
  @override
  RouteInformation restoreRouteInformation(Uri configuration) {
    return RouteInformation(uri: configuration);
  }
}
