import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class SubPage extends StatefulWidget {
  const SubPage({super.key});

  @override
  State<SubPage> createState() => _SubPageState();
}

class _SubPageState extends State<SubPage> {
  @override
  void initState() {
    if (kDebugMode) {
      print("_SubPageState");
    }
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
    final number = SN.to.getPathParameter("number");
    return Scaffold(
      backgroundColor: Colors.purple,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("PAGE: $number"),
            const Padding(padding: EdgeInsets.only(top: 12)),
            ElevatedButton(
              onPressed: () {
                // SN.to.pop("Teste de resultado");
                SN.to.push("/sub/${getRandomInteger()}");
              },
              child: const Text("GO"),
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            ElevatedButton(
              onPressed: () {
                SN.to.pop("Teste de resultado $number");
              },
              child: const Text("BACK"),
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            ElevatedButton(
              onPressed: () {
                SN.to.replaceCurrent("/sub/1000");
              },
              child: const Text("REPLACE"),
            ),
            const Padding(padding: EdgeInsets.only(top: 12)),
            ElevatedButton(
              onPressed: () {
                SN.to.push("/feed");
              },
              child: const Text("OPEN"),
            ),
          ],
        ),
      ),
    );
  }
}
