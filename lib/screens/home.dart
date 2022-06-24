import 'package:fitlah/screens/day-view/calorie-stats.dart';
import 'package:fitlah/screens/day-view/day-view.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/heading_widget.dart';
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

  @override
  void initState() {
    super.initState();
  }

  onClickDayViewScreenButton(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => DayViewScreen()));
  }

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    final ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: Text("Welcome to Fitlah",
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 30)),
            subtitle: Text(
              // authService.getCurrentUser()!.email!,
              "Shanta Tei",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          _buildDaysBar(),
          InkWell(
            onTap: () {
              onClickDayViewScreenButton(context);
            },
            child: Container(
              height: 200,
              width: 350,
              margin: EdgeInsets.only(bottom: 20, top: 20),
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
                                "Running",
                                style: TextStyle(
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "2500",
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
                          style: TextStyle(
                              color: kBlackColor, fontWeight: FontWeight.w600),
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
          InkWell(
            onTap: () {
              onClickDayViewScreenButton(context);
            },
            child: Container(
              height: 200,
              width: 350,
              margin: EdgeInsets.only(bottom: 20, top: 20),
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
                                "Calories",
                                style: TextStyle(
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                "960",
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
                          "1200",
                          style: CustomTextStyle.metricTextStyle,
                        ),
                        Text(
                          " " + "kcal",
                          style: TextStyle(
                              color: kBlackColor, fontWeight: FontWeight.w600),
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
    ));
  }

  Widget _buildCard({color1, text1, text2, text3, text4, faicon}) {
    return Container(
      height: 200,
      width: 350,
      margin: EdgeInsets.only(bottom: 20, top: 20),
      decoration: BoxDecoration(
          color: color1, borderRadius: BorderRadius.circular(20.0)),
      child: Stack(
        children: [
          Positioned(
              top: 20,
              left: 20,
              child: Container(
                child: Row(children: [
                  FaIcon(
                    faicon,
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
                        text1,
                        style: TextStyle(
                            color: kBlackColor, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        text2,
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
                  text3,
                  style: CustomTextStyle.metricTextStyle,
                ),
                Text(
                  " " + text4,
                  style: TextStyle(
                      color: kBlackColor, fontWeight: FontWeight.w600),
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
    );
  }

  Container _buildDaysBar() {
    return Container(
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Text(
          'Today',
          style: CustomTextStyle.dayTabBarStyleActive,
        ),
        Text(
          'Week',
          style: CustomTextStyle.dayTabBarStyleInactive,
        ),
        Text(
          'Month',
          style: CustomTextStyle.dayTabBarStyleInactive,
        ),
        Text(
          'Year',
          style: CustomTextStyle.dayTabBarStyleInactive,
        )
      ]),
    );
  }
}
