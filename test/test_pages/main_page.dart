import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("MAIN PAGE"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await SN.to.push(
                  "/tabs",
                );
                if (kDebugMode) {
                  print(result);
                }
              },
              child: const Text("GO TO SUB TABS"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var result = await SN.to.push(
                  "/sub/0?outro=true",
                  queryParameters: {
                    "teste": "true",
                  },
                );
                if (kDebugMode) {
                  print(result);
                }
              },
              child: const Text("GO"),
            ),
          ],
        ),
      ),
    );
  }
}
