import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  void initState() {
    if (kDebugMode) {
      print("_TabsPageState");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleNavigatorTabsBuilder(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.purple,
          bottomNavigationBar: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Home",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "Settings",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "Profile",
              )
            ],
            currentIndex: () {
              if (SN.to.currentTab == "/main") {
                return 0;
              } else if (SN.to.currentTab == "/settings") {
                return 1;
              }
              return 2;
            }(),
            onTap: (index) {
              if (index == 2) {
                SN.to.tab("/profile");
              } else if (index == 1) {
                SN.to.tab("/settings");
              } else {
                SN.to.tab("/main");
              }
            },
          ),
          body: widget.child,
        );
      },
    );
  }
}
