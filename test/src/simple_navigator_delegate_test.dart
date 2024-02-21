import 'package:flutter_test/flutter_test.dart';
import 'package:simple_navigator/simple_navigator.dart';

import '../bootstrap.dart';

void main() {
  testWidgets('Test simple navigator delegate simple push and pop',
      (tester) async {
    await Bootstrap.setup(tester);

    await SN.to.setInitialRoutePath(Uri.parse("/"));
    expect(SN.to.currentConfiguration, isNull);

    final splash = find.text("SPLASH PAGE");
    expect(splash, findsOneWidget);

    await tester.pumpAndSettle(const Duration(milliseconds: 1005));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
    final main = find.text("MAIN PAGE");

    expect(main, findsOneWidget);

    SN.to.push("/sub/0");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/0");
    expect(SN.to.currentConfiguration?.toString(), "/sub/0");

    final sub0 = find.text("SUB PAGE: 0");
    expect(sub0, findsOneWidget);

    SN.to.push("/sub/1");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/1");
    expect(SN.to.currentConfiguration?.toString(), "/sub/1");

    final sub1 = find.text("SUB PAGE: 1");
    expect(sub1, findsOneWidget);

    SN.to.pop();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    final pSub0 = find.text("SUB PAGE: 0");
    expect(pSub0, findsOneWidget);

    SN.to.pop();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    final pMain = find.text("MAIN PAGE");
    expect(pMain, findsOneWidget);
  });

  testWidgets('Test simple navigator delegate pop by web browser back button',
      (tester) async {
    await Bootstrap.setup(tester);

    await SN.to.setInitialRoutePath(Uri.parse("/"));
    expect(SN.to.currentConfiguration, isNull);

    final splash = find.text("SPLASH PAGE");
    expect(splash, findsOneWidget);

    await tester.pumpAndSettle(const Duration(milliseconds: 1005));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
    final main = find.text("MAIN PAGE");

    expect(main, findsOneWidget);

    SN.to.push("/sub/0");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/0");
    expect(SN.to.currentConfiguration?.toString(), "/sub/0");

    final sub0 = find.text("SUB PAGE: 0");
    expect(sub0, findsOneWidget);

    SN.to.push("/sub/1");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/1");
    expect(SN.to.currentConfiguration?.toString(), "/sub/1");

    final sub1 = find.text("SUB PAGE: 1");
    expect(sub1, findsOneWidget);

    SN.to.setNewRoutePath(Uri.parse("/sub/0"));
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    final pSub0 = find.text("SUB PAGE: 0");
    expect(pSub0, findsOneWidget);

    SN.to.setNewRoutePath(Uri.parse("/?tab=main"));
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    final pMain = find.text("MAIN PAGE");
    expect(pMain, findsOneWidget);
  });

  testWidgets('Test simple navigator delegate pop by mobile back button',
      (tester) async {
    await Bootstrap.setup(tester);

    await SN.to.setInitialRoutePath(Uri.parse("/"));
    expect(SN.to.currentConfiguration, isNull);

    final splash = find.text("SPLASH PAGE");
    expect(splash, findsOneWidget);

    await tester.pumpAndSettle(const Duration(milliseconds: 1005));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
    final main = find.text("MAIN PAGE");

    expect(main, findsOneWidget);

    SN.to.push("/sub/0");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/0");
    expect(SN.to.currentConfiguration?.toString(), "/sub/0");

    final sub0 = find.text("SUB PAGE: 0");
    expect(sub0, findsOneWidget);

    SN.to.push("/sub/1");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/1");
    expect(SN.to.currentConfiguration?.toString(), "/sub/1");

    final sub1 = find.text("SUB PAGE: 1");
    expect(sub1, findsOneWidget);

    SN.to.popRoute();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    final pSub0 = find.text("SUB PAGE: 0");
    expect(pSub0, findsOneWidget);

    SN.to.popRoute();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    final pMain = find.text("MAIN PAGE");
    expect(pMain, findsOneWidget);
  });

  testWidgets('Test simple navigator delegate web browser forward',
      (tester) async {
    await Bootstrap.setup(tester);

    await SN.to.setInitialRoutePath(Uri.parse("/"));
    expect(SN.to.currentConfiguration, isNull);

    final splash = find.text("SPLASH PAGE");
    expect(splash, findsOneWidget);

    await tester.pumpAndSettle(const Duration(milliseconds: 1005));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
    final main = find.text("MAIN PAGE");

    expect(main, findsOneWidget);

    SN.to.push("/sub/0");
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/0");
    expect(SN.to.currentConfiguration?.toString(), "/sub/0");

    final sub0 = find.text("SUB PAGE: 0");
    expect(sub0, findsOneWidget);

    SN.to.setNewRoutePath(Uri.parse("/sub/1"));
    expect(SN.to.currentConfiguration, isNull);

    await tester.pumpAndSettle(const Duration(milliseconds: 55));
    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/1");
    expect(SN.to.currentConfiguration?.toString(), "/sub/1");

    final sub1 = find.text("SUB PAGE: 1");
    expect(sub1, findsOneWidget);
  });

  testWidgets('Test simple navigator delegate popUntil', (tester) async {
    await Bootstrap.setup(tester);

    await SN.to.setInitialRoutePath(Uri.parse("/"));
    expect(SN.to.currentConfiguration, isNull);

    final splash = find.text("SPLASH PAGE");
    expect(splash, findsOneWidget);

    await tester.pumpAndSettle(const Duration(milliseconds: 1005));
    final sn = SN.of(SN.navigatorKey.currentContext!);

    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
    final main = find.text("MAIN PAGE");

    expect(main, findsOneWidget);

    for (var i = 0; i <= 5; i++) {
      sn.push("/sub/$i", queryParameters: {
        "test": "true"
      }, extras: {
        "extra": "param",
      });

      expect(SN.to.currentConfiguration, isNull);

      await tester.pumpAndSettle(const Duration(milliseconds: 55));

      expect(SN.to.currentConfiguration?.path, "/sub/$i");
      expect(SN.to.currentConfiguration?.toString(), "/sub/$i?test=true");
      final q = sn.getQueryParameter("test");
      expect(q, "true");

      final p = sn.getPathParameter("number");
      expect(p, "$i");

      final e = sn.getExtraParameter("extra");
      expect(e, "param");

      final sub = find.text("SUB PAGE: $i");
      expect(sub, findsOneWidget);
    }

    sn.popUntil("/sub", mostCloser: true);
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/5");
    expect(SN.to.currentConfiguration?.toString(), "/sub/5?test=true");

    final sub5 = find.text("SUB PAGE: 5");
    expect(sub5, findsOneWidget);

    sn.popUntil("/sub", mostCloser: false);
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/sub/0");
    expect(SN.to.currentConfiguration?.toString(), "/sub/0?test=true");

    final sub0 = find.text("SUB PAGE: 0");
    expect(sub0, findsOneWidget);

    sn.pop();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));

    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
  });

  testWidgets('Test simple navigator delegate tabs navigation', (tester) async {
    await Bootstrap.setup(tester);

    await SN.to.setInitialRoutePath(Uri.parse("/"));
    expect(SN.to.currentConfiguration, isNull);

    final splash = find.text("SPLASH PAGE");
    expect(splash, findsOneWidget);

    Future<void> checkMain() async {
      await tester.pumpAndSettle(const Duration(milliseconds: 1005));
      expect(SN.to.currentConfiguration, isNotNull);
      expect(SN.to.currentConfiguration?.path, "/");
      expect(SN.to.currentConfiguration?.toString(), "/?tab=main");
      final main = find.text("MAIN PAGE");
      expect(main, findsOneWidget);
    }

    await checkMain();
    SN.to.tab("/settings");
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=settings");
    final settings = find.text("SETTINGS PAGE");
    expect(settings, findsOneWidget);

    SN.to.pop();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));
    await checkMain();

    SN.to.tab("/profile");
    await tester.pumpAndSettle(const Duration(milliseconds: 400));

    expect(SN.to.currentConfiguration, isNotNull);
    expect(SN.to.currentConfiguration?.path, "/");
    expect(SN.to.currentConfiguration?.toString(), "/?tab=profile");
    final profile = find.text("PROFILE PAGE");
    expect(profile, findsOneWidget);

    SN.to.pop();
    await tester.pumpAndSettle(const Duration(milliseconds: 20));
    await checkMain();
  });
}
