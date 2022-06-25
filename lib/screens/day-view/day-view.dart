import 'package:fitlah/models/food_track_task.dart';
import 'package:fitlah/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utils/constants.dart';
import '../../utils/theme_colors.dart';
import 'calorie-stats.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class DayViewScreen extends StatefulWidget {
  DayViewScreen();

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
  Color _rightArrowColor = Color(0xffC1C1C1);
  Color _leftArrowColor = Color(0xffC1C1C1);
  final _addFoodKey = GlobalKey<FormState>();

  DatabaseService databaseService =
      new DatabaseService(uid: DATABASE_UID, currentDate: DateTime.now());

  late FoodTrackTask addFoodTrack;

  @override
  void initState() {
    super.initState();
    addFoodTrack = FoodTrackTask(
        email: "",
        food_name: "",
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        mealTime: "",
        createdOn: _value,
        grams: 0);
    databaseService.getFoodTrackData(DATABASE_UID);
  }

  void resetFoodTrack() {
    addFoodTrack = FoodTrackTask(
        email: "",
        food_name: "",
        calories: 0,
        carbs: 0,
        protein: 0,
        fat: 0,
        mealTime: "",
        createdOn: _value,
        grams: 0);
  }

  Widget _calorieCounter() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: new Container(
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
            CalorieStats(datePicked: _value),
          ],
        ),
      ),
    );
  }

  Widget _backButton() {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios),
      iconSize: 20,
      color: Colors.white,
      onPressed: () async {
        Navigator.of(context).pop();
      },
    );
  }

  Widget _addFoodButton() {
    return IconButton(
      icon: Icon(Icons.add_box),
      iconSize: 25,
      color: Colors.white,
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
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  if (checkFormValid()) {
                    Navigator.pop(context);
                    var random = new Random();
                    int randomMilliSecond = random.nextInt(1000);
                    addFoodTrack.createdOn = _value;
                    addFoodTrack.createdOn = addFoodTrack.createdOn
                        .add(Duration(milliseconds: randomMilliSecond));
                    databaseService.addFoodTrackEntry(addFoodTrack);
                    resetFoodTrack();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Food Added Successfully'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Invalid form data! All numeric fields must contain numeric values greater than 0"),
                      backgroundColor: Colors.white,
                    ));
                  }
                },
                child: Text('Ok'),
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
          decoration: InputDecoration(
            label: Text('Mealtime'),
          ),
          items: [
            DropdownMenuItem(child: Text('Breakfast'), value: 'breakfast'),
            DropdownMenuItem(child: Text('Lunch'), value: 'lunch'),
            DropdownMenuItem(child: Text('Dinner'), value: 'dinner'),
            DropdownMenuItem(child: Text('Supper'), value: 'supper'),
          ],
          validator: (value) {
            if (value == null)
              return "Please provide a mealtime";
            else
              return null;
          },
          onChanged: (value) {
            addFoodTrack.mealTime = value as String;
          },
        )
      ]),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
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
        body: StreamProvider<List<FoodTrackTask>>.value(
          initialData: [],
          value: new DatabaseService(
                  uid: DATABASE_UID, currentDate: DateTime.now())
              .foodTracks,
          child: new Column(children: <Widget>[
            _showDatePicker(),
            _calorieCounter(),
            Expanded(
                child: ListView(
              children: <Widget>[
                FoodTrackList(datePicked: _value),
              ],
            ))
          ]),
        )
        
        );
  }
}

class FoodTrackList extends StatelessWidget {
  final DateTime datePicked;
  FoodTrackList({required this.datePicked});

  @override
  Widget build(BuildContext context) {
    final DateTime curDate =
        new DateTime(datePicked.year, datePicked.month, datePicked.day);

    final foodTracks = Provider.of<List<FoodTrackTask>>(context);

    List findCurScans(List foodTrackFeed) {
      List curScans = [];
      foodTrackFeed.forEach((foodTrack) {
        DateTime scanDate = DateTime(foodTrack.createdOn.year,
            foodTrack.createdOn.month, foodTrack.createdOn.day);
        if (scanDate.compareTo(curDate) == 0) {
          curScans.add(foodTrack);
        }
      });
      return curScans;
    }

    List curScans = findCurScans(foodTracks);

    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: curScans.length + 1,
      itemBuilder: (context, index) {
        if (index < curScans.length) {
          return FoodTrackTile(foodTrackEntry: curScans[index]);
        } else {
          return SizedBox(height: 5);
        }
      },
    );
  }
}

class FoodTrackTile extends StatefulWidget {
  final FoodTrackTask foodTrackEntry;

  FoodTrackTile({required this.foodTrackEntry});

  @override
  State<FoodTrackTile> createState() => _FoodTrackTileState();
}

class _FoodTrackTileState extends State<FoodTrackTile> {
  var form = GlobalKey<FormState>();
  DatabaseService databaseService =
      new DatabaseService(uid: DATABASE_UID, currentDate: DateTime.now());

  List macros = CalorieStats.macroData;
  // late FoodTrackTask widget.foodTrackEntry;
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  double servingSize = 0;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Color(0xff5FA55A),
        child: _itemCalories(),
      ),
      title: Text(widget.foodTrackEntry.food_name,
          style: TextStyle(
            fontSize: 16.0,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w500,
          )),
      subtitle: _macroData(),
      children: <Widget>[
        _expandedView(context),
      ],
    );
  }

  checkFormValid() {
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      return true;
    }
    return false;
  }

  _editFoodToAdd(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Edit Food '),
            content: _editAmountHad(),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context), // passing false
                child: Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  if (checkFormValid()) {
                    Navigator.pop(context);
                    databaseService.editFoodTrackEntry(widget.foodTrackEntry);
                    form.currentState!.reset();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Food Updated Successfully'),
                    ));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                          "Invalid form data! All numeric fields must contain numeric values greater than 0"),
                      backgroundColor: Colors.white,
                    ));
                  }
                },
                child: Text('Ok'),
              ),
            ],
          );
        });
  }

  Widget _editAmountHad() {
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        _editFoodForm(),
      ]),
    );
  }

  Widget _editFoodForm() {
    return Form(
      key: form,
      child: Column(children: [
        TextFormField(
          initialValue: widget.foodTrackEntry.food_name,
          decoration: const InputDecoration(
            labelText: "Name *",
            hintText: "Please enter food name",
            errorStyle: TextStyle(color: Colors.red),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter the food name";
            }
            return null;
          },
          onChanged: (value) {
            widget.foodTrackEntry.food_name = value;
            // addFood.calories = value;
          },
        ),
        TextFormField(
          initialValue: widget.foodTrackEntry.calories.toString(),
          decoration: const InputDecoration(
            labelText: "Calories *",
            hintText: "Please enter a calorie amount",
            errorStyle: TextStyle(color: Colors.red),
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
              widget.foodTrackEntry.calories = int.parse(value);
            } catch (e) {
              // return "Please enter numeric values"
              widget.foodTrackEntry.calories = 0;
            }
            // addFood.calories = value;
          },
          // onSaved: (value) {
          //   widget.foodTrackEntry.calories = int.parse(value!);
          // },
        ),
        TextFormField(
          initialValue: widget.foodTrackEntry.carbs.toString(),
          decoration: const InputDecoration(
            labelText: "Carbs *",
            hintText: "Please enter a carbs amount",
            errorStyle: TextStyle(color: Colors.red),
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
              widget.foodTrackEntry.carbs = int.parse(value);
            } catch (e) {
              widget.foodTrackEntry.carbs = 0;
            }
          },
        ),
        TextFormField(
          initialValue: widget.foodTrackEntry.protein.toString(),
          decoration: const InputDecoration(
            labelText: "Protein *",
            hintText: "Please enter a protein amount",
            errorStyle: TextStyle(color: Colors.red),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a calorie amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              widget.foodTrackEntry.protein = int.parse(value);
            } catch (e) {
              widget.foodTrackEntry.protein = 0;
            }
          },
        ),
        TextFormField(
          initialValue: widget.foodTrackEntry.fat.toString(),
          decoration: const InputDecoration(
            labelText: "Fat *",
            hintText: "Please enter a fat amount",
            errorStyle: TextStyle(color: Colors.red),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter a fat amount";
            }
            return null;
          },
          onChanged: (value) {
            try {
              widget.foodTrackEntry.fat = int.parse(value);
            } catch (e) {
              widget.foodTrackEntry.fat = 0;
            }
          },
        ),
        TextFormField(
          initialValue: widget.foodTrackEntry.grams.toString(),
          decoration: const InputDecoration(
            labelText: "Grams *",
            hintText: "eg. 100",
            errorStyle: TextStyle(color: Colors.red),
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
              widget.foodTrackEntry.grams = int.parse(value);
            } catch (e) {
              widget.foodTrackEntry.grams = 0;
            }

            setState(() {
              servingSize = double.tryParse(value) ?? 0;
            });
          },
        ),
        DropdownButtonFormField(
          decoration: InputDecoration(
            label: Text('Mealtime'),
          ),
          items: [
            DropdownMenuItem(child: Text('Breakfast'), value: 'breakfast'),
            DropdownMenuItem(child: Text('Lunch'), value: 'lunch'),
            DropdownMenuItem(child: Text('Dinner'), value: 'dinner'),
            DropdownMenuItem(child: Text('Supper'), value: 'supper'),
          ],
          value: widget.foodTrackEntry.mealTime,
          validator: (value) {
            if (value == null)
              return "Please provide a mealtime";
            else
              return null;
          },
          onChanged: (value) {
            widget.foodTrackEntry.mealTime = value as String;
          },
        )
      ]),
    );
  }

  Widget _itemCalories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.foodTrackEntry.calories.toStringAsFixed(0),
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )),
        Text('kcal',
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }

  Widget _macroData() {
    return Row(
      children: <Widget>[
        Container(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(CARBS_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                      ' ' +
                          widget.foodTrackEntry.carbs.toStringAsFixed(1) +
                          'g    ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(PROTEIN_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                      ' ' +
                          widget.foodTrackEntry.protein.toStringAsFixed(1) +
                          'g    ',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: Color(FAT_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ' + widget.foodTrackEntry.fat.toStringAsFixed(1) + 'g',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
              Text(widget.foodTrackEntry.grams.toString() + 'g',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w300,
                  )),
            ],
          ),
        )
      ],
    );
  }

  Widget _expandedView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0.0, 15.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          expandedHeader(context),
          _expandedCalories(),
          _expandedCarbs(),
          _expandedProtein(),
          _expandedFat(),
        ],
      ),
    );
  }

  Widget expandedHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text('% of total',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            )),
        IconButton(
            icon: Icon(Icons.edit),
            iconSize: 16,
            onPressed: () async {
              _editFoodToAdd(context);
              print("Edit button pressed");
            }),
        IconButton(
            icon: Icon(Icons.delete),
            iconSize: 16,
            onPressed: () async {
              print("Delete button pressed");
              databaseService.deleteFoodTrackEntry(widget.foodTrackEntry);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Food Deleted Successfully'),
              ));
            }),
      ],
    );
  }

  Widget _expandedCalories() {
    double caloriesValue = 0;
    if (!(widget.foodTrackEntry.calories / macros[0]).isNaN) {
      caloriesValue = widget.foodTrackEntry.calories / macros[0];
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: caloriesValue,
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff5FA55A)),
            ),
          ),
          Text('      ' + ((caloriesValue) * 100).toStringAsFixed(0) + '%',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              )),
        ],
      ),
    );
  }

  Widget _expandedCarbs() {
    double carbsValue = 0;
    if (!(widget.foodTrackEntry.carbs / macros[2]).isNaN) {
      carbsValue = widget.foodTrackEntry.carbs / macros[2];
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: carbsValue,
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFA5457)),
            ),
          ),
          Text('      ' + ((carbsValue) * 100).toStringAsFixed(0) + '%'),
        ],
      ),
    );
  }

  Widget _expandedProtein() {
    double proteinValue = 0;
    if (!(widget.foodTrackEntry.protein / macros[1]).isNaN) {
      proteinValue = widget.foodTrackEntry.protein / macros[1];
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: proteinValue,
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFA8925)),
            ),
          ),
          Text('      ' + ((proteinValue) * 100).toStringAsFixed(0) + '%'),
        ],
      ),
    );
  }

  Widget _expandedFat() {
    double fatValue = 0;
    if (!(widget.foodTrackEntry.fat / macros[3]).isNaN) {
      fatValue = widget.foodTrackEntry.fat / macros[3];
    }
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
      child: Row(
        children: <Widget>[
          Container(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (widget.foodTrackEntry.fat / macros[3]),
              backgroundColor: Color(0xffEDEDED),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xff01B4BC)),
            ),
          ),
          Text('      ' + ((fatValue) * 100).toStringAsFixed(0) + '%'),
        ],
      ),
    );
  }

  // void setState(Null Function() param0) {}
}
