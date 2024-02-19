import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    if (kDebugMode) {
      print("_HomePageState");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            SN.to.tab("/profile", this);
          } else if (index == 1) {
            SN.to.tab("/settings", this);
          } else {
            SN.to.tab("/main", this);
          }
        },
      ),
      body: widget.child,
    );
  }
}
