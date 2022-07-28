import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitlah/models/food_track_task.dart';
import 'package:fitlah/models/goals.dart';
import 'package:fitlah/models/user.dart';
import 'package:fitlah/models/water_intake_task.dart';
import 'package:fitlah/services/goals_service.dart';
import 'package:fitlah/services/user_service.dart';
import 'package:fitlah/services/water_service.dart';
import 'package:fitlah/screens/home/widgets/calorie-stats-simplified_widget.dart';
import 'package:fitlah/screens/calories_intake/calories_intake_screen.dart';
import 'package:fitlah/screens/water_intake/water_intake_screen.dart';
import 'package:fitlah/services/calories_service.dart';
import 'package:fitlah/utils/constants.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

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
  final Color _leftArrowColor = const Color(0xffC1C1C1);
  UserModel? _userModel;
  String? username = "";

  @override
  void initState() {
    super.initState();
  }

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
    WaterService fsService = WaterService();

    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      body: StreamBuilder<List<WaterIntakeTask>>(
        stream: fsService.getWater(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                        if (user.hasData) {
                          _userModel = user.data;
                          username = _userModel?.username;
                        }
                        return StreamProvider<List<FoodTrackTask>>.value(
                          initialData: const [],
                          value: DatabaseService(
                            uid: DATABASE_UID,
                            currentDate: DateTime.now(),
                          ).foodTracks,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, top: 8),
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
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        username!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 25,
                                        ),
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
                                    margin: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 233, 20, 5),
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
                                                  FontAwesomeIcons.running,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: const [
                                                    Text(
                                                      "RUNNING",
                                                      style: CustomTextStyle
                                                          .metricTextStyle2,
                                                    ),
                                                    Text(
                                                      "2500" "m",
                                                      style: CustomTextStyle
                                                          .metricTextStyle,
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
                                            child: Row(children: [
                                              Text(
                                                goals.hasData &&
                                                        goals.data!.isNotEmpty
                                                    ? goals.data!.first.steps
                                                        .toString()
                                                    : "10000",
                                                style: CustomTextStyle
                                                    .metricTextStyle,
                                              ),
                                              const Text(
                                                " " "m",
                                                style: CustomTextStyle
                                                    .metricTextStyle2,
                                              )
                                            ]),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 10,
                                            width: 260,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: LinearProgressIndicator(
                                                value: 2500 /
                                                    (goals.hasData &&
                                                            goals.data!
                                                                .isNotEmpty
                                                        ? goals
                                                            .data!.first.steps
                                                            .toDouble()
                                                        : 10000),
                                                valueColor:
                                                    const AlwaysStoppedAnimation(
                                                  Colors.white,
                                                ),
                                                backgroundColor: kLightColor
                                                    .withOpacity(0.2),
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
                                    margin: const EdgeInsets.only(
                                        bottom: 8, top: 8),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "CALORIES",
                                                      style: CustomTextStyle
                                                          .metricTextStyle2,
                                                    ),
                                                    TotalCalories(
                                                        datePicked: _value)
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        //Chart

                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 20,
                                              top: 50,
                                            ),
                                            child: CalorieStatsSimplified(
                                              datePicked: _value,
                                            ),
                                          ),
                                        ),

                                        //Progress Bar
                                        // Align(
                                        //   alignment: Alignment.center,
                                        //   child: Container(
                                        //     height: 10,
                                        //     width: 260,
                                        //     child: ClipRRect(
                                        //       borderRadius: BorderRadius.circular(10.0),
                                        //       child: LinearProgressIndicator(
                                        //         value: 100 / 2000,
                                        //         valueColor: AlwaysStoppedAnimation(Colors.white),
                                        //         backgroundColor: kLightColor.withOpacity(0.2),
                                        //       ),
                                        //     ),
                                        //   ),
                                        // )
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
                                    margin: const EdgeInsets.only(
                                        bottom: 8, top: 8),
                                    decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius:
                                            BorderRadius.circular(20.0)),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                            top: 20,
                                            left: 20,
                                            child: Container(
                                              child: Row(children: [
                                                const FaIcon(
                                                  FontAwesomeIcons.glassWater,
                                                  color: Colors.white,
                                                  size: 35,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "WATER INTAKE",
                                                      style: CustomTextStyle
                                                          .metricTextStyle2,
                                                    ),
                                                    Text(
                                                      sum.toStringAsFixed(0) +
                                                          "ml",
                                                      style: CustomTextStyle
                                                          .metricTextStyle,
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
                                                goals.hasData &&
                                                        goals.data!.isNotEmpty
                                                    ? goals
                                                        .data!.first.waterintake
                                                        .toString()
                                                    : "2000",
                                                style: CustomTextStyle
                                                    .metricTextStyle,
                                              ),
                                              const Text(
                                                " " "ml",
                                                style: CustomTextStyle
                                                    .metricTextStyle2,
                                              )
                                            ]),
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 10,
                                            width: 260,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: LinearProgressIndicator(
                                                value: sum /
                                                    (goals.hasData &&
                                                            goals.data!
                                                                .isNotEmpty
                                                        ? goals.data!.first
                                                            .waterintake
                                                        : 2000),
                                                valueColor:
                                                    const AlwaysStoppedAnimation(
                                                        Colors.white),
                                                backgroundColor: kLightColor
                                                    .withOpacity(0.2),
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
                        );
                      });
                });
          }
        },
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

class TotalCalories extends StatelessWidget {
  final DateTime datePicked;
  num displayCalories = 0;
  TotalCalories({required this.datePicked});
  static List<num> macroData = [];

  @override
  Widget build(BuildContext context) {
    final DateTime curDate =
        DateTime(datePicked.year, datePicked.month, datePicked.day);

    final foodTracks = Provider.of<List<FoodTrackTask>>(context);

    List findCurScans(List<FoodTrackTask> foodTracks) {
      List currentFoodTracks = [];
      for (var foodTrack in foodTracks) {
        DateTime trackDate = DateTime(foodTrack.createdOn.year,
            foodTrack.createdOn.month, foodTrack.createdOn.day);
        if (trackDate.compareTo(curDate) == 0) {
          currentFoodTracks.add(foodTrack);
        }
      }
      return currentFoodTracks;
    }

    List currentFoodTracks = findCurScans(foodTracks);

    void findTotalCalories(List foodTracks) {
      for (var scan in foodTracks) {
        displayCalories += scan.calories;
      }
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
