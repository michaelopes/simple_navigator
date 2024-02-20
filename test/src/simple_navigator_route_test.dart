import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_navigator/simple_navigator.dart';

void main() {
  test('Test simple navigator route', () async {
    final route = SimpleNavigatorRoute(
      path: "/login/:id",
      builder: (_) => Container(),
    );
    final extractedParams = route.extractParams("/login/25");
    expect(extractedParams["id"], "25");
    expect(route.hasMatch("/login/25"), isTrue);
    expect(route.hasMatch("/login/6541"), isTrue);
    expect(route.path, "/login/:id");
  });

  test('Test simple navigator without params', () async {
    final route = SimpleNavigatorRoute(
      path: "/login",
      builder: (_) => Container(),
    );
    final extractedParams = route.extractParams("/login/25");
    expect(extractedParams.entries.length, 0);
    expect(route.hasMatch("/login"), isTrue);
    expect(route.hasMatch("/login"), isTrue);
    expect(route.path, "/login");
  });

  test('Test simple navigator route with number regex', () async {
    const path = r'/login/:id(\d+)';
    final route = SimpleNavigatorRoute(
      path: path,
      builder: (_) => Container(),
    );
    final extractedParams = route.extractParams("/login/25");
    expect(extractedParams["id"], "25");
    expect(route.hasMatch("/login/25"), isTrue);
    expect(route.hasMatch("/login/michael"), isFalse);
    expect(route.path, path);
  });
}
