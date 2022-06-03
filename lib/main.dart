import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fitlah/screens/home.dart';
import 'package:fitlah/screens/login_signup.dart';
import 'package:fitlah/screens/profile.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MainScreen(),
        debugShowCheckedModeBanner: false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Fitlah")),
      body: LoginSignupScreen(),
      // body: SizedBox.expand(
      //   child: PageView(
      //     controller: _pageController,
      //     onPageChanged: (index) {
      //       setState(() => _currentIndex = index);
      //     },
      //     children: <Widget>[
      //       Container(
      //         child: Home(),
      //       ),
      //       Container(
      //         child: LoginSignupScreen(),
      //       ),
      //       Container(
      //         color: Colors.green,
      //       ),
      //       Container(
      //         child: Profile(),
      //       ),
      //     ],
      //   ),
      // ),
      // bottomNavigationBar: BottomNavyBar(
      //   selectedIndex: _currentIndex,
      //   onItemSelected: (index) {
      //     setState(() => _currentIndex = index);
      //     _pageController.jumpToPage(index);
      //   },
      //   items: <BottomNavyBarItem>[
      //     BottomNavyBarItem(
      //       title: Text('Home'),
      //       icon: Icon(Icons.home),
      //       activeColor: Color.fromARGB(255, 250, 25, 209),
      //     ),
      //     BottomNavyBarItem(
      //       title: Text('Item Two'),
      //       icon: Icon(Icons.apps),
      //       activeColor: Colors.red,
      //     ),
      //     BottomNavyBarItem(
      //       title: Text('Item Three'),
      //       icon: Icon(Icons.chat_bubble),
      //       activeColor: Colors.green,
      //     ),
      //     BottomNavyBarItem(
      //       title: Text('Profile'),
      //       icon: Icon(Icons.settings),
      //       activeColor: Colors.blue,
      //     ),
      //   ],
      // ),
    );
  }
}
