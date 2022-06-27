import 'package:fitlah/models/food_track_task.dart';
import 'package:fitlah/widgets/calorie-stats-simplified_widget.dart';
import 'package:fitlah/screens/day-view_screen.dart';
import 'package:fitlah/screens/water_intake_screen.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/services/database.dart';
import 'package:fitlah/utils/constants.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/all_water_intake.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = Color(0xffC1C1C1);
  Color _leftArrowColor = Color(0xffC1C1C1);

  @override
  void initState() {
    super.initState();
  }

  onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DayViewScreen()));
  }

  onClickWaterIntakeScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => WaterIntake()));
  }

  @override
  Widget build(BuildContext context) {
    AllWaterIntake waterintakeList = Provider.of<AllWaterIntake>(context);

    // AuthService authService = AuthService();

    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        body: StreamProvider<List<FoodTrackTask>>.value(
      initialData: [],
      value: new DatabaseService(uid: DATABASE_UID, currentDate: DateTime.now())
          .foodTracks,
      child: SingleChildScrollView(
        child: new Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Welcome to ",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 30),
                  ),
                  Text(
                    "FITLAH",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: themeColor),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Shanta Tei",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 25),
                  ),
                ],
              ),
            ),
            _showDatePicker(),
            //Running Card
            InkWell(
              onTap: () {},
              child: Container(
                height: 200,
                width: 350,
                margin: EdgeInsets.only(bottom: 8, top: 8),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 233, 20, 5),
                    borderRadius: BorderRadius.circular(20.0)),
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          child: Row(children: [
                            FaIcon(
                              FontAwesomeIcons.running,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "RUNNING",
                                  style: CustomTextStyle.metricTextStyle2,
                                ),
                                Text(
                                  "2500" + "m",
                                  style: CustomTextStyle.metricTextStyle,
                                )
                              ],
                            )
                          ]),
                        )),
                    Positioned(
                      top: 150,
                      left: 20,
                      child: Container(
                        child: Row(children: [
                          Text(
                            "4000",
                            style: CustomTextStyle.metricTextStyle,
                          ),
                          Text(
                            " " + "m",
                            style: CustomTextStyle.metricTextStyle2,
                          )
                        ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 10,
                        width: 260,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: kLightColor.withOpacity(0.2),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //Calories Card
            InkWell(
              onTap: () {
                onClickDayViewScreenButton(context);
              },
              child: Container(
                height: 250,
                width: 350,
                margin: EdgeInsets.only(bottom: 8, top: 8),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          child: Row(children: [
                            FaIcon(
                              FontAwesomeIcons.utensils,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "CALORIES",
                                  style: CustomTextStyle.metricTextStyle2,
                                ),
                                TotalCalories(datePicked: _value)
                              ],
                            )
                          ]),
                        )),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20, top: 50),
                        child: CalorieStatsSimplified(datePicked: _value),
                      ),
                    )
                  ],
                ),
              ),
            ),
            //Water Intake Card
            InkWell(
              onTap: () {
                onClickWaterIntakeScreenButton(context);
              },
              child: Container(
                height: 200,
                width: 350,
                margin: EdgeInsets.only(bottom: 8, top: 8),
                decoration: BoxDecoration(
                    color: themeColor,
                    borderRadius: BorderRadius.circular(20.0)),
                child: Stack(
                  children: [
                    Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          child: Row(children: [
                            FaIcon(
                              FontAwesomeIcons.glassWater,
                              color: Colors.white,
                              size: 35,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Water Intake",
                                  style: CustomTextStyle.metricTextStyle2,
                                ),
                                Text(
                                  waterintakeList
                                          .getTotalWater()
                                          .toStringAsFixed(0) +
                                      "ml",
                                  style: CustomTextStyle.metricTextStyle,
                                )
                              ],
                            )
                          ]),
                        )),
                    Positioned(
                      top: 150,
                      left: 20,
                      child: Container(
                        child: Row(children: [
                          Text(
                            "2000",
                            style: CustomTextStyle.metricTextStyle,
                          ),
                          Text(
                            " " + "ml",
                            style: CustomTextStyle.metricTextStyle2,
                          )
                        ]),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 10,
                        width: 260,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: LinearProgressIndicator(
                            value: 0.6,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: kLightColor.withOpacity(0.2),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: new DateTime(2019),
      lastDate: new DateTime.now(),
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
    if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
      setState(() => _rightArrowColor = Color(0xffEDEDED));
    } else
      setState(() => _rightArrowColor = Colors.white);
  }

  Widget _showDatePicker() {
    return Container(
      width: 250,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_left, size: 25.0),
            color: Colors.black,
            onPressed: () {
              setState(() {
                _value = _value.subtract(Duration(days: 1));
                _rightArrowColor = Colors.black;
              });
            },
          ),
          TextButton(
            // textColor: Colors.white,
            onPressed: () => _selectDate(),
            // },
            child: Text(_dateFormatter(_value),
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Open Sans',
                  fontSize: 18.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          IconButton(
              icon: Icon(Icons.arrow_right, size: 25.0),
              color: _rightArrowColor,
              onPressed: () {
                if (today.difference(_value).compareTo(Duration(days: 1)) ==
                    -1) {
                  setState(() {
                    _rightArrowColor = Color.fromARGB(113, 0, 0, 0);
                  });
                } else {
                  setState(() {
                    _value = _value.add(Duration(days: 1));
                  });
                  if (today.difference(_value).compareTo(Duration(days: 1)) ==
                      -1) {
                    setState(() {
                      _rightArrowColor = Color.fromARGB(113, 0, 0, 0);
                    });
                  }
                }
              }),
        ],
      ),
    );
  }

  String _dateFormatter(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
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

class TotalCalories extends StatelessWidget {
  final DateTime datePicked;
  num displayCalories = 0;
  TotalCalories({required this.datePicked});
  static List<num> macroData = [];

  @override
  Widget build(BuildContext context) {
    final DateTime curDate =
        new DateTime(datePicked.year, datePicked.month, datePicked.day);

    final foodTracks = Provider.of<List<FoodTrackTask>>(context);

    List findCurScans(List<FoodTrackTask> foodTracks) {
      List currentFoodTracks = [];
      foodTracks.forEach((foodTrack) {
        DateTime trackDate = DateTime(foodTrack.createdOn.year,
            foodTrack.createdOn.month, foodTrack.createdOn.day);
        if (trackDate.compareTo(curDate) == 0) {
          currentFoodTracks.add(foodTrack);
        }
      });
      return currentFoodTracks;
    }

    List currentFoodTracks = findCurScans(foodTracks);

    void findTotalCalories(List foodTracks) {
      foodTracks.forEach((scan) {
        displayCalories += scan.calories;
      });
    }

    findTotalCalories(currentFoodTracks);

    macroData = [displayCalories];

    displayCalories = 0;

    return Text(
      macroData[0].toStringAsFixed(0) + "kcal",
      style: CustomTextStyle.metricTextStyle,
    );
  }
}
