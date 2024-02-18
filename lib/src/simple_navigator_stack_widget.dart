import 'package:flutter/material.dart';
import 'simple_navigator_stack_handler.dart';

class SimpleNavigatorStackWidget extends StatefulWidget {
  const SimpleNavigatorStackWidget({
    Key? key,
    //required this.pages,
    required this.navigatorKey,
    required this.stackHandler,
    // required this.onPopPage,
  }) : super(key: key);

  // final List<Page> pages;
  final GlobalKey<NavigatorState> navigatorKey;
  final SimpleNavigatorStackHandler stackHandler;
  // final PopPageCallback? onPopPage;

  @override
  State<SimpleNavigatorStackWidget> createState() =>
      SimpleNavigatorStackWidgetState();
}

typedef StackWidgetStateListener = void Function();

class SimpleNavigatorStackWidgetState
    extends State<SimpleNavigatorStackWidget> {
  late SimpleNavigatorStackHandler stackHandler;

  @override
  void initState() {
    super.initState();
    stackHandler = widget.stackHandler;
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    stackHandler = widget.stackHandler;
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant SimpleNavigatorStackWidget oldWidget) {
    if (widget != oldWidget) {
      stackHandler = widget.stackHandler;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return stackHandler.pages.isEmpty
        ? const SizedBox.shrink()
        : Navigator(
            restorationScopeId: "root",
            key: widget.navigatorKey,
            observers: const [],
            pages: stackHandler.pages,
            onPopPage: (route, result) {
              if (route.didPop(result)) {
                return stackHandler.pop(result);
              }
              return false;
            },
          );
  }
}
