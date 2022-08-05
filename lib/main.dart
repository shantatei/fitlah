import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlah/screens/home/home_screen.dart';
import 'package:fitlah/screens/auth/login_signup_screen.dart';
import 'package:fitlah/screens/profile/profile_screen.dart';
import 'package:fitlah/screens/auth/reset_password_screen.dart';
import 'package:fitlah/screens/auth/user_detail_screen.dart';
import 'package:fitlah/screens/runnning_tracker/all_runs.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.getAuthUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(snapshot.data?.email!)
              .snapshots(),
          builder: (context, usersnapshot) {
            return MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: checkSnapshots(snapshot, usersnapshot),
                routes: {
                  LoginSignupScreen.routeName: (_) {
                    return LoginSignupScreen();
                  },
                  ResetPasswordScreen.routeName: (_) {
                    return ResetPasswordScreen();
                  },
                },
                debugShowCheckedModeBanner: false);
          },
        );
      },
    );
  }

  Widget checkSnapshots(
    AsyncSnapshot<User?> authsnapshot,
    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> usersnapshot,
  ) {
    // if (authsnapshot.connectionState == ConnectionState.waiting) {
    //   return const SplashScreen();
    // }

    // if (usersnapshot.connectionState == ConnectionState.waiting) {
    //   return const SplashScreen();
    // }

    if (!authsnapshot.hasData) {
      return LoginSignupScreen();
    }

    if (usersnapshot.hasData && usersnapshot.data!.exists) {
      return MainScreen();
    }

    return UserDetailScreen();
  }
}

class MainScreen extends StatefulWidget {
  int? index;

  MainScreen({this.index});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late List<Widget> children;

  @override
  void initState() {
    super.initState();
    children = <Widget>[
      Container(
        child: Home(),
      ),
      Container(
        child: const AllRuns(),
      ),
      Container(
        child: Profile(),
      ),
    ];

    if (widget.index != null) {
      _currentIndex = widget.index!;
    }
  }

  AuthService authService = AuthService();

  logOut() {
    return authService.logOut().then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Logout successfully!'),
      ));
    }).catchError((error) {
      FocusScope.of(context).unfocus();
      String message = error.toString();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Fitlah",
          style: TextStyle(color: themeColor),
        ),
        actions: [
          IconButton(
              onPressed: () => logOut(),
              icon: const Icon(
                Icons.logout,
                color: themeColor,
              ))
        ],
      ),
      body: SizedBox.expand(
        child: children[_currentIndex],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: const Text('Home'),
            icon: const Icon(Icons.home),
            activeColor: const Color.fromARGB(255, 15, 3, 226),
          ),
          BottomNavyBarItem(
            title: const Text('Your Runs'),
            icon: const FaIcon(FontAwesomeIcons.running),
            activeColor: const Color.fromARGB(255, 15, 3, 226),
          ),
          BottomNavyBarItem(
            title: const Text('Profile'),
            icon: const FaIcon(FontAwesomeIcons.user),
            activeColor: const Color.fromARGB(255, 15, 3, 226),
          ),
        ],
      ),
    );
  }
}
