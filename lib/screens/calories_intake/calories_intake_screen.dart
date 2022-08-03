import 'package:fitlah/models/calorie.dart';
import 'package:fitlah/screens/calories_intake/widgets/calorie_list_widget.dart';
import 'package:fitlah/services/calories_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth_service.dart';
import '../../utils/theme_colors.dart';
import 'widgets/calorie_stats_widget.dart';

class DayViewScreen extends StatefulWidget {
  const DayViewScreen();

  @override
  State<StatefulWidget> createState() {
    return _DayViewState();
  }
}

class _DayViewState extends State<DayViewScreen> {
  String title = 'Add Food';
  double servingSize = 0;
  String dropdownValue = 'grams';
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  Color _rightArrowColor = const Color(0xffC1C1C1);
  final _addFoodKey = GlobalKey<FormState>();
  final String email = AuthService().getCurrentUser()!.email!;

  late Calorie addFoodTrack;

  @override
  void initState() {
    super.initState();
    addFoodTrack = Calorie(
      email: "",
      food_name: "",
      calories: 0,
      carbs: 0,
      protein: 0,
      fat: 0,
      mealTime: "",
      createdOn: _value,
      grams: 0,
    );
  }

  void resetFoodTrack() {
    addFoodTrack = Calorie(
      email: "",
      food_name: "",
      calories: 0,
      carbs: 0,
      protein: 0,
      fat: 0,
      mealTime: "",
      createdOn: _value,
      grams: 0,
    );
  }

  Widget _calorieCounter(AsyncSnapshot<List<Calorie>> caloriesnapshot) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
                bottom: BorderSide(
              color: Colors.grey.withOpacity(0.5),
              width: 1.5,
            ))),
        height: 220,
        child: Row(
          children: <Widget>[
            CalorieStats(foodList: caloriesnapshot.data!),
          ],
        ),
      ),
    );
  }

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

  Widget _addFoodButton() {
    return IconButton(
      icon: const Icon(Icons.add_box),
      iconSize: 25,
      color: themeColor,
      onPressed: () async {
        setState(() {});
        _showFoodToAdd(context);
      },
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

  checkFormValid() {
    bool isValid = _addFoodKey.currentState!.validate();
    if (isValid) {
      _addFoodKey.currentState!.save();
      return true;
    }
    return false;
  }

  _showFoodToAdd(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: _showAmountHad(),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context), // passing false
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  if (checkFormValid()) {
                    Navigator.pop(context);
                    addFoodTrack.createdOn = _value;
                    addFoodTrack.email = email;
                    CalorieService.instance().insertCalorie(addFoodTrack);
                    resetFoodTrack();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Food Added Successfully'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text(
                          "Invalid form data! All numeric fields must contain numeric values greater than 0"),
                      backgroundColor: Colors.white,
                    ));
                  }
                },
                child: const Text('Ok'),
              ),
            ],
          );
        });
  }

  Widget _showAmountHad() {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        _showAddFoodForm(),
      ]),
    );
  }

  Widget _showAddFoodForm() {
    return Form(
      key: _addFoodKey,
      child: Column(children: [
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Name *",
            hintText: "Please enter food name",
            errorStyle: TextStyle(color: Colors.red),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the food name";
            }
            return null;
          },
          onChanged: (value) {
            addFoodTrack.food_name = value;
            // addFood.calories = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Calories *",
            hintText: "Please enter a calorie amount",
            errorStyle: TextStyle(color: Colors.red),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          onChanged: (value) {
            try {
              addFoodTrack.calories = int.parse(value);
            } catch (e) {
              // return "Please enter numeric values"
              addFoodTrack.calories = 0;
            }
            // addFood.calories = value;
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Carbs *",
            hintText: "Please enter a carbs amount",
            errorStyle: TextStyle(color: Colors.red),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a carbs amount";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          onChanged: (value) {
            try {
              addFoodTrack.carbs = int.parse(value);
            } catch (e) {
              addFoodTrack.carbs = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Protein *",
            hintText: "Please enter a protein amount",
            errorStyle: TextStyle(color: Colors.red),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              addFoodTrack.protein = int.parse(value);
            } catch (e) {
              addFoodTrack.protein = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Fat *",
            hintText: "Please enter a fat amount",
            errorStyle: TextStyle(color: Colors.red),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a fat amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              addFoodTrack.fat = int.parse(value);
            } catch (e) {
              addFoodTrack.fat = 0;
            }
          },
        ),
        TextFormField(
          decoration: const InputDecoration(
            labelText: "Grams *",
            hintText: "eg. 100",
            errorStyle: TextStyle(color: Colors.red),
            // errorBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the amount of grams";
            }
            return null;
          },
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          onChanged: (value) {
            try {
              addFoodTrack.grams = int.parse(value);
            } catch (e) {
              addFoodTrack.grams = 0;
            }

            setState(() {
              servingSize = double.tryParse(value) ?? 0;
            });
          },
        ),
        DropdownButtonFormField(
          decoration: const InputDecoration(
            label: Text('Mealtime'),
          ),
          items: const [
            DropdownMenuItem(child: Text('Breakfast'), value: 'breakfast'),
            DropdownMenuItem(child: Text('Lunch'), value: 'lunch'),
            DropdownMenuItem(child: Text('Dinner'), value: 'dinner'),
            DropdownMenuItem(child: Text('Supper'), value: 'supper'),
          ],
          validator: (value) {
            if (value == null) {
              return "Please provide a mealtime";
            } else {
              return null;
            }
          },
          onChanged: (value) {
            addFoodTrack.mealTime = value as String;
          },
        )
      ]),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _backButton(),
                _addFoodButton(),
              ],
            ),
          )),
      body: StreamBuilder<List<Calorie>>(
        stream: CalorieService.instance().getCaloriebyDate(_value),
        builder: (context, caloriesnapshot) {
          if (caloriesnapshot.connectionState == ConnectionState.waiting ||
              !caloriesnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: <Widget>[
              _showDatePicker(),
              _calorieCounter(caloriesnapshot),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    CalorieList(caloriesnapshot: caloriesnapshot)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
