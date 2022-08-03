import 'package:fitlah/main.dart';
import 'package:fitlah/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigatetoLogin();
  }

  _navigatetoLogin() async {
    await Future.delayed(const Duration(milliseconds: 1500), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(child: Image.asset('images/fitlahlogo-dark.png')),
      ),
    );
  }
}
