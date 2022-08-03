import 'package:fitlah/models/calorie.dart';
import 'package:fitlah/models/goals.dart';
import 'package:fitlah/models/user.dart';
import 'package:fitlah/models/water.dart';
import 'package:fitlah/services/calories_service.dart';
import 'package:fitlah/services/goals_service.dart';
import 'package:fitlah/services/user_service.dart';
import 'package:fitlah/services/water_service.dart';
import 'package:fitlah/screens/calories_intake/calories_intake_screen.dart';
import 'package:fitlah/screens/water_intake/water_intake_screen.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = const Color(0xffC1C1C1);
  UserModel? _userModel;
  String? username = "";

  onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const DayViewScreen()));
  }

  onClickWaterIntakeScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WaterIntake()));
  }

  @override
  Widget build(BuildContext context) {

    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: StreamBuilder<List<WaterIntakeTask>>(
        stream: WaterService.instance().getWaterbyDate(_value),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            double sum = 0;
            for (var doc in snapshot.data!) {
              sum += doc.water;
            }
            return StreamBuilder<List<Goals>>(
              stream: GoalService.instance().getGoal(),
              builder: (context, goals) {
                return StreamBuilder<UserModel?>(
                  stream: UserService.instance().getUserStream(),
                  builder: (context, user) {
                    if (user.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (user.hasData) {
                      _userModel = user.data;
                      username = _userModel?.username;
                    }
                    return StreamBuilder<List<Calorie>>(
                      stream:
                          CalorieService.instance().getCaloriebyDate(_value),
                      builder: (context, caloriesnapshot) {
                        if (caloriesnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        num caloriesum = 0;
                        for (var doc in caloriesnapshot.data!) {
                          caloriesum = doc.calories;
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              _getHeader(),
                              _getUserName(),
                              _showDatePicker(),
                              //Calories Card
                              _getCalorieIntakeCard(context, caloriesum, goals),
                              //Water Intake Card
                              _getWaterIntakeCard(context, sum, goals),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  InkWell _getCalorieIntakeCard(
      BuildContext context, num caloriesum, AsyncSnapshot<List<Goals>> goals) {
    return InkWell(
      onTap: () {
        onClickDayViewScreenButton(context);
      },
      child: Container(
        height: 200,
        width: 350,
        margin: const EdgeInsets.only(bottom: 8, top: 8),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.utensils,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "CALORIES",
                          style: CustomTextStyle.metricTextStyle2,
                        ),
                        Text(
                          caloriesum.toString() + "kcal",
                          style: CustomTextStyle.metricTextStyle,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 20,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      goals.hasData && goals.data!.isNotEmpty
                          ? goals.data!.first.caloriesintake.toString()
                          : "2000",
                      style: CustomTextStyle.metricTextStyle,
                    ),
                    const Text(
                      " " "ml",
                      style: CustomTextStyle.metricTextStyle2,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 10,
                width: 260,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    value: caloriesum /
                        (goals.hasData && goals.data!.isNotEmpty
                            ? goals.data!.first.caloriesintake
                            : 2000),
                    valueColor: const AlwaysStoppedAnimation(
                      Colors.white,
                    ),
                    backgroundColor: kLightColor.withOpacity(0.2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InkWell _getWaterIntakeCard(
      BuildContext context, double sum, AsyncSnapshot<List<Goals>> goals) {
    return InkWell(
      onTap: () {
        onClickWaterIntakeScreenButton(context);
      },
      child: Container(
        height: 200,
        width: 350,
        margin: const EdgeInsets.only(bottom: 8, top: 8),
        decoration: BoxDecoration(
            color: themeColor, borderRadius: BorderRadius.circular(20.0)),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                child: Row(
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.glassWater,
                      color: Colors.white,
                      size: 35,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "WATER INTAKE",
                          style: CustomTextStyle.metricTextStyle2,
                        ),
                        Text(
                          sum.toStringAsFixed(0) + "ml",
                          style: CustomTextStyle.metricTextStyle,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 20,
              child: Container(
                child: Row(
                  children: [
                    Text(
                      goals.hasData && goals.data!.isNotEmpty
                          ? goals.data!.first.waterintake.toString()
                          : "2000",
                      style: CustomTextStyle.metricTextStyle,
                    ),
                    const Text(
                      " " "ml",
                      style: CustomTextStyle.metricTextStyle2,
                    )
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                height: 10,
                width: 260,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    value: sum /
                        (goals.hasData && goals.data!.isNotEmpty
                            ? goals.data!.first.waterintake
                            : 2000),
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    backgroundColor: kLightColor.withOpacity(0.2),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding _getUserName() {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            username!.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

  Padding _getHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          Text(
            "Welcome to ",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 30,
            ),
          ),
          Text(
            "FITLAH",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: themeColor,
            ),
          ),
        ],
      ),
    );
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0xff5FA55A), //Head background
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _value = picked);
    _stateSetter();
  }

  void _stateSetter() {
    if (today.difference(_value).compareTo(const Duration(days: 1)) == -1) {
      setState(() => _rightArrowColor = const Color(0xffEDEDED));
    } else {
      setState(() => _rightArrowColor = Colors.white);
    }
  }

  Widget _showDatePicker() {
    return SizedBox(
      width: 250,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.arrow_left, size: 25.0),
            color: Colors.black,
            onPressed: () {
              setState(() {
                _value = _value.subtract(const Duration(days: 1));
                _rightArrowColor = Colors.black;
              });
            },
          ),
          TextButton(
            // textColor: Colors.white,
            onPressed: () => _selectDate(),
            // },
            child: Text(_dateFormatter(_value),
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          IconButton(
              icon: const Icon(Icons.arrow_right, size: 25.0),
              color: _rightArrowColor,
              onPressed: () {
                if (today
                        .difference(_value)
                        .compareTo(const Duration(days: 1)) ==
                    -1) {
                  setState(() {
                    _rightArrowColor = const Color.fromARGB(113, 0, 0, 0);
                  });
                } else {
                  setState(() {
                    _value = _value.add(const Duration(days: 1));
                  });
                  if (today
                          .difference(_value)
                          .compareTo(const Duration(days: 1)) ==
                      -1) {
                    setState(() {
                      _rightArrowColor = const Color.fromARGB(113, 0, 0, 0);
                    });
                  }
                }
              }),
        ],
      ),
    );
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    String month;

    switch (tm.month) {
      case 1:
        month = "Jan";
        break;
      case 2:
        month = "Feb";
        break;
      case 3:
        month = "Mar";
        break;
      case 4:
        month = "Apr";
        break;
      case 5:
        month = "May";
        break;
      case 6:
        month = "Jun";
        break;
      case 7:
        month = "Jul";
        break;
      case 8:
        month = "Aug";
        break;
      case 9:
        month = "Sep";
        break;
      case 10:
        month = "Oct";
        break;
      case 11:
        month = "Nov";
        break;
      case 12:
        month = "Dec";
        break;
      default:
        month = "Undefined";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
  }
}
