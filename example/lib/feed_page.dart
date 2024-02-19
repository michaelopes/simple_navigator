import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    if (kDebugMode) {
      print("_FeedPageState");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                SN.to.pop();
              },
              child: const Text("BACK"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                SN.to.popUntil(
                  "/sub",
                  result: "Teste de resultado",
                  mostCloser: false,
                );
              },
              child: const Text("POP UNTIL SUB"),
            ),
          ],
        ),
      ),
    );
  }
}
