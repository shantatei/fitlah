import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlah/screens/home.dart';
import 'package:fitlah/screens/login_signup.dart';
import 'package:fitlah/screens/profile.dart';
import 'package:fitlah/screens/reset_password.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:flutter/material.dart';

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
        });
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
        title: Text("Fitlah"),
        actions: [
          IconButton(onPressed: () => logOut(), icon: Icon(Icons.logout))
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
              color: Colors.red,
            ),
            Container(
              color: Colors.green,
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
            activeColor: Color.fromARGB(255, 250, 25, 209),
          ),
          BottomNavyBarItem(
            title: Text('Item Two'),
            icon: Icon(Icons.apps),
            activeColor: Colors.red,
          ),
          BottomNavyBarItem(
            title: Text('Item Three'),
            icon: Icon(Icons.chat_bubble),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            title: Text('Profile'),
            icon: Icon(Icons.settings),
            activeColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
