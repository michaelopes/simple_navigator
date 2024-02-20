import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:simple_navigator/src/simple_navigator_dialog_handler.dart';
import 'package:simple_navigator/src/simple_navigator_stack_handler.dart';

import '../globals.dart';

void main() {
  late SimpleNavigatorDialogHandler mockDialogHandler;
  setUp(() {
    mockDialogHandler = MockDialogHandler();
  });

  test('Test stack handler simple push and pop', () async {
    when(() => mockDialogHandler.pop(any(), any())).thenReturn(false);
    int countNotifiers = 0;
    final stackHandler = SimpleNavigatorStackHandler(
      availableRoutes: testParams.routes,
      getContext: () {
        return mockedBuildContext;
      },
      notifyListeners: () {
        countNotifiers++;
      },
      dialogHandler: mockDialogHandler,
    );

    stackHandler.loadInitialRoute();
    expect(stackHandler.lastUri, isNull);
    expect(stackHandler.pages.last.name, "/page-guard-loading");

    await Future.delayed(const Duration(milliseconds: 1005));

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    for (var i = 0; i < 2; i++) {
      stackHandler.push("/sub/$i");

      expect(stackHandler.lastUri, isNull);
      expect(stackHandler.pages.last.name, "/page-guard-loading");

      await Future.delayed(const Duration(milliseconds: 55));

      expect(stackHandler.pages.last.name, "/sub/$i");
      expect(stackHandler.lastUri, isNotNull);
      expect(stackHandler.lastUri?.path, "/sub/$i");
      expect(stackHandler.lastUri?.toString(), "/sub/$i");
    }

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isFalse);

    stackHandler.pop();

    expect(stackHandler.pages.last.name, "/sub/0");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/sub/0");
    expect(stackHandler.lastUri?.toString(), "/sub/0");

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isFalse);

    stackHandler.pop();

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    expect(countNotifiers, 7);
  });

  test('Test stack handler popUntil', () async {
    when(() => mockDialogHandler.pop(any(), any())).thenReturn(false);
    int countNotifiers = 0;
    final stackHandler = SimpleNavigatorStackHandler(
      availableRoutes: testParams.routes,
      getContext: () {
        return mockedBuildContext;
      },
      notifyListeners: () {
        countNotifiers++;
      },
      dialogHandler: mockDialogHandler,
    );

    stackHandler.loadInitialRoute();
    expect(stackHandler.lastUri, isNull);
    expect(stackHandler.pages.last.name, "/page-guard-loading");

    await Future.delayed(const Duration(milliseconds: 1005));

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    for (var i = 0; i <= 5; i++) {
      stackHandler.push("/sub/$i");

      expect(stackHandler.lastUri, isNull);
      expect(stackHandler.pages.last.name, "/page-guard-loading");

      await Future.delayed(const Duration(milliseconds: 55));

      expect(stackHandler.pages.last.name, "/sub/$i");
      expect(stackHandler.lastUri, isNotNull);
      expect(stackHandler.lastUri?.path, "/sub/$i");
      expect(stackHandler.lastUri?.toString(), "/sub/$i");
    }

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isFalse);

    stackHandler.popUntil("/sub", mostCloser: true);

    expect(stackHandler.pages.last.name, "/sub/5");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/sub/5");
    expect(stackHandler.lastUri?.toString(), "/sub/5");

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isFalse);

    stackHandler.popUntil("/sub", mostCloser: false);

    expect(stackHandler.pages.last.name, "/sub/0");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/sub/0");
    expect(stackHandler.lastUri?.toString(), "/sub/0");

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isFalse);

    stackHandler.popUntil("/", mostCloser: false);

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    expect(countNotifiers, 15);
  });

  test('Test stack handler tabs navigation', () async {
    when(() => mockDialogHandler.pop(any(), any())).thenReturn(false);

    int countNotifiers = 0;

    final stackHandler = SimpleNavigatorStackHandler(
      availableRoutes: testParams.routes,
      getContext: () {
        return mockedBuildContext;
      },
      notifyListeners: () {
        countNotifiers++;
      },
      dialogHandler: mockDialogHandler,
    );

    stackHandler.loadInitialRoute();
    expect(stackHandler.lastUri, isNull);
    expect(stackHandler.pages.last.name, "/page-guard-loading");

    await Future.delayed(const Duration(milliseconds: 1005));

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    stackHandler.setCurrentTab("/", "/settings");

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=settings");

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isTrue);

    stackHandler.pop();

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    stackHandler.setCurrentTab("/", "/profile");

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=profile");

    expect(stackHandler.canPop(), isTrue);
    expect(stackHandler.canPopTab(), isTrue);

    stackHandler.pop();

    expect(stackHandler.pages.last.name, "/");
    expect(stackHandler.lastUri, isNotNull);
    expect(stackHandler.lastUri?.path, "/");
    expect(stackHandler.lastUri?.toString(), "/?tab=main");

    expect(countNotifiers, 5);
  });
}
