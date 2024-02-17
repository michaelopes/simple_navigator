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
    print("AKI");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            var result = await SN.to.push(
              "/sub/0?outro=true",
              queryParameters: {
                "teste": "true",
              },
            );
            print(result);
          },
          child: const Text("LOGIN GO"),
        ),
      ),
    );
  }
}
