import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    if (kDebugMode) {
      print("_ProfilePageState");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            SN.of(context).push("/tabs");
          },
          child: const Text("PROFILE GO TO SUB TABS"),
        ),
      ),
    );
  }
}
