import 'dart:math';

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
    print("_HomePageState");
    super.initState();
  }

  int getRandomInteger() {
    final random = Random();
    return random.nextInt(1000);
  }

  @override
  Widget build(BuildContext context) {
    /* var d = AR.to.getParam("tester");
    print("AKIIR $d");*/
    //  var state = SN.of(context);

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
          if (SN.to.currentTab == "/feed") {
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
            SN.to.tab("/feed", this);
          }
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: widget.child,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                var result = await SN.to.push(
                  "/sub/${getRandomInteger()}?outro=true",
                  queryParameters: {
                    "teste": "true",
                  },
                );
                print(result);
              },
              child: const Text("GO"),
            ),
          ),
        ],
      ),
    );
  }
}
