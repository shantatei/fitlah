import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlah/providers/all_water_intake.dart';
import 'package:fitlah/providers/goals_provider.dart';
import 'package:fitlah/screens/explore_screen.dart';
import 'package:fitlah/screens/home_screen.dart';
import 'package:fitlah/screens/login_signup_screen.dart';
import 'package:fitlah/screens/profile_screen.dart';
import 'package:fitlah/screens/record_screen.dart';
import 'package:fitlah/screens/reset_password_screen.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AllWaterIntake>(
          create: (ctx) => AllWaterIntake(),
        ),
        ChangeNotifierProvider<GoalsProvider>(
          create: (ctx) => GoalsProvider(),
        )
      ],
      child: StreamBuilder<User?>(
          stream: authService.getAuthUser(),
          builder: (context, snapshot) {
            return MaterialApp(
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                home: snapshot.connectionState == ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : snapshot.hasData
                        ? MainScreen()
                        : LoginSignupScreen(),
                routes: {
                  LoginSignupScreen.routeName: (_) {
                    return LoginSignupScreen();
                  },
                  ResetPasswordScreen.routeName: (_) {
                    return ResetPasswordScreen();
                  },
                },
                debugShowCheckedModeBanner: false);
          }),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  AuthService authService = AuthService();
  logOut() {
    return authService.logOut().then((value) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
        title: Text(
          "Fitlah",
          style: TextStyle(color: themeColor),
        ),
        actions: [
          IconButton(
              onPressed: () => logOut(),
              icon: Icon(
                Icons.logout,
                color: themeColor,
              ))
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Container(
              child: Home(),
            ),
            Container(
              child: Record(),
            ),
            Container(
              child: Explore(),
            ),
            Container(
              child: Profile(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            title: Text('Home'),
            icon: Icon(Icons.home),
            activeColor: Color.fromARGB(255, 15, 3, 226),
          ),
          BottomNavyBarItem(
            title: Text('Record'),
            icon: FaIcon(FontAwesomeIcons.recordVinyl),
            activeColor: Color.fromARGB(255, 15, 3, 226),
          ),
          BottomNavyBarItem(
            title: Text('Explore'),
            icon: Icon(Icons.explore),
            activeColor: Color.fromARGB(255, 15, 3, 226),
          ),
          BottomNavyBarItem(
            title: Text('Profile'),
            icon: FaIcon(FontAwesomeIcons.user),
            activeColor: Color.fromARGB(255, 15, 3, 226),
          ),
        ],
      ),
    );
  }
}
