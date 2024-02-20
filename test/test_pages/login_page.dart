import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        children: [
          const Text("LOGIN PAGE"),
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
            child: const Text("LOGIN GO"),
          ),
        ],
      ),
    );
  }
}
