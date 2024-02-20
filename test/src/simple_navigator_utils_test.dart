import 'package:flutter_test/flutter_test.dart';
import 'package:simple_navigator/src/simple_navigator_utils.dart';

void main() {
  test('Test Toolkit validade route name', () async {
    expect(Toolkit.isValidRoutePath("/user"), isTrue);
    expect(Toolkit.isValidRoutePath("/user/:id/:name"), isTrue);
    expect(Toolkit.isValidRoutePath(r'/user/:id(\d+)/:name'), isTrue);
    expect(Toolkit.isValidRoutePath(r'/user/:id(\d+)/:name/teste/:lastname'),
        isTrue);
    expect(Toolkit.isValidRoutePath(r'/user/:id(\d+)/:name/teste?teste=123'),
        isFalse);
    expect(Toolkit.isValidRoutePath(r'/user/%id(\d+)/:name/teste'), isFalse);
    expect(Toolkit.isValidRoutePath(r'\user/%id(\d+)/:name/teste'), isFalse);
  });
}
