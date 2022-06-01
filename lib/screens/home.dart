import 'package:fitlah/screens/day-view/day-view.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FlatButton(
          onPressed: () {
            // Navigate back to Home
          },
          child: const Text('Go Back!'),
        ),
      ),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  void onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DayViewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        body: new Column(
      children: <Widget>[
        new ListTile(
            leading: const Icon(Icons.food_bank),
            title: new Text("Welcome To Calorie Tracker App!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold))),
        new ElevatedButton(
            onPressed: () {
              onClickDayViewScreenButton(context);
            },
            child: Text("Day View Screen")),
      ],
    ));
  }
}
