import 'package:flutter/material.dart';
import 'package:simple_navigator/simple_navigator.dart';

class SplashPage extends StatefulWidget
    with SimpleNavigatorSplashCompleterMixin {
  SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 10), () {
      widget.complete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {},
          child: const Text("SPLASH"),
        ),
      ),
    );
  }
}
