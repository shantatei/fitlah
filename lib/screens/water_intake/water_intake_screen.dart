import 'package:fitlah/models/water.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/screens/water_intake/widgets/waterintake_list_widget.dart';
import 'package:flutter/material.dart';
import '../../services/water_service.dart';

class WaterIntake extends StatefulWidget {
  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = const Color(0xffC1C1C1);
  var form = GlobalKey<FormState>();

  double? waterintake;
  DateTime? createdon;

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
    if (tm.month < 0 || tm.month > 12) {
      month = "Undefined";
    } else {
      month = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ][tm.month - 1];
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

  void addWater() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();

      createdon = DateTime.now();

      WaterService.instance().addWater(waterintake, createdon);

      // Hide the keyboard
      FocusScope.of(context).unfocus();
      // Resets the form
      form.currentState!.reset();
      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Water intake added successfully!'),
        ),
      );
    }
  }

  // List<WaterIntakeTask> myWaterIntakeTask = [];

  @override
  Widget build(BuildContext context) {
    Widget _backButton() {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        iconSize: 20,
        color: themeColor,
        onPressed: () async {
          Navigator.of(context).pop();
        },
      );
    }

    return StreamBuilder<List<WaterIntakeTask>>(
      stream: WaterService.instance().getWaterbyDate(_value),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: AppBar(
                  iconTheme: const IconThemeData(
                    color: themeColor, //change your color here
                  ),
                  backgroundColor: Colors.white,
                ),
                body: Column(
                  children: [
                    _showDatePicker(),
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
                        child: SizedBox(
                          width: 200,
                          child: TextFormField(
                            decoration: const InputDecoration(
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
                                fontSize: 14,
                                color: Color(textColor1),
                              ),
                              errorStyle: TextStyle(color: Colors.red),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please provide the water amount!";
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              waterintake = double.parse(value!);
                            },
                          ),
                        ),
                      ),
                    ),
                    OutlinedButton(
                      style:
                          OutlinedButton.styleFrom(backgroundColor: themeColor),
                      onPressed: () {
                        addWater();
                      },
                      child: const Text(
                        "Add Glasses",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      child: snapshot.data!.isNotEmpty
                          ? SizedBox(
                              height: 200,
                              child: WaterintakeList(waterList: snapshot.data!),
                            )
                          : Column(
                              children: const [
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  'No Water added yet , add a new one today!',
                                  style: CustomTextStyle.metricTextStyle2,
                                )
                              ],
                            ),
                    )
                  ],
                ),
              );
      },
    );
  }
}
