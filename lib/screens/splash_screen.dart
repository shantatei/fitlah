import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlah/main.dart';
import 'package:fitlah/screens/auth/login_signup_screen.dart';
import 'package:fitlah/screens/auth/user_detail_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  // final AsyncSnapshot<User?> authsnapshot;
  // final AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> usersnapshot;

  const SplashScreen({
    Key? key,
    // required this.authsnapshot,
    // required this.usersnapshot,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // _checksnapshots();
  }

  // _checksnapshots() async {
  //   await Future.delayed(const Duration(milliseconds: 1500), () {});
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) {
  //         if (!widget.authsnapshot.hasData) {
  //           return LoginSignupScreen();
  //         }

  //         if (widget.usersnapshot.hasData && widget.usersnapshot.data!.exists) {
  //           return MainScreen();
  //         }

  //         return UserDetailScreen();
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Image.asset('images/fitlahlogo-dark.png'),
        ),
      ),
    );
  }
}
