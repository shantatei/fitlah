import 'package:fitlah/models/water_intake_task.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/screens/water_intake/widgets/waterintake_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../services/water_service.dart';

class WaterIntake extends StatefulWidget {
  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  var form = GlobalKey<FormState>();

  double? waterintake;
  DateTime? createdon;

  void addWater() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();

      createdon = DateTime.now();

      WaterService fsService = WaterService();
      fsService.addWater(waterintake, createdon);
      // intakeList.addWaterIntake(waterintake, createdon);

      // Hide the keyboard
      FocusScope.of(context).unfocus();
      // Resets the form
      form.currentState!.reset();
      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Water intake added successfully!'),
      ));
    }
  }

  // List<WaterIntakeTask> myWaterIntakeTask = [];

  @override
  Widget build(BuildContext context) {
    WaterService fsService = WaterService();
    // AllWaterIntake waterintakeList = Provider.of<AllWaterIntake>(context);

    Widget _backButton() {
      return IconButton(
        icon: Icon(Icons.arrow_back_ios),
        iconSize: 20,
        color: themeColor,
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    }

    return StreamBuilder<List<WaterIntakeTask>>(
        stream: fsService.getWater(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  resizeToAvoidBottomInset: false,
                  appBar: AppBar(
                    iconTheme: IconThemeData(
                      color: themeColor, //change your color here
                    ),
                    backgroundColor: Colors.white,
                  ),
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // FaIcon(FontAwesomeIcons.minusCircle),
                            Image.asset(
                              'images/water_bottle.png',
                              width: 150,
                            ),
                            // FaIcon(FontAwesomeIcons.plusCircle)
                          ],
                        ),
                      ),
                      Form(
                          key: form,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 200,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: "Water Intake (ml)",
                                  hintText: "Please enter your Water Intake",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    // borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                    // borderRadius: BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  contentPadding: EdgeInsets.all(10),
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Color(textColor1)),
                                  errorStyle: TextStyle(color: Colors.red),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please provide the water amount!";
                                  } else
                                    return null;
                                },
                                onSaved: (value) {
                                  waterintake = double.parse(value!);
                                },
                              ),
                            ),
                          )),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 8.0),
                      //   child: Text(
                      //     "1x Glass 240ml",
                      //     style: CustomTextStyle.metricTextStyle2,
                      //   ),
                      // ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            backgroundColor: themeColor),
                        onPressed: () {
                          addWater();
                        },
                        child: Text(
                          "Add Glasses",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                          child: snapshot.data!.length > 0
                              ? Container(
                                  height: 200,
                                  child: WaterintakeList(),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'No Water addded yet , add a new one today!',
                                      style: CustomTextStyle.metricTextStyle2,
                                    )
                                  ],
                                ))
                    ],
                  ),
                );
        });
  }
}
