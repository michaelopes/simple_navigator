import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

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
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
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
    );
  }
}
