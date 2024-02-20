import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_navigator/src/simple_navigator_dialog_handler.dart';

class MockDialogRoute extends Mock implements DialogRoute {}

class MockMaterialRoute extends Mock implements MaterialPageRoute {}

class MockNavigator extends Mock implements NavigatorState {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) => "";
}

void main() {
  test('Test dialog handler', () async {
    final navigator = MockNavigator();
    when(() => navigator.canPop()).thenReturn(true);

    final dialogHandler = SimpleNavigatorDialogHandler(
      getRouteReferenceId: () => "1234",
      customNavigator: navigator,
    );

    dialogHandler.didPush(MockMaterialRoute(), null);

    expect(dialogHandler.pop("1234", null), isFalse);

    dialogHandler.didPush(MockDialogRoute(), null);

    expect(dialogHandler.pop("1234", null), isTrue);
    expect(dialogHandler.pop("1234", null), isFalse);
  });
}
