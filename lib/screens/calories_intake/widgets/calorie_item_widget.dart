import 'package:fitlah/services/calories_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../models/calorie.dart';
import '../../../utils/theme_colors.dart';
import 'calorie_stats_widget.dart';

class CalorieItem extends StatefulWidget {
  final Calorie foodTrackEntry;
  const CalorieItem({Key? key, required this.foodTrackEntry}) : super(key: key);

  @override
  State<CalorieItem> createState() => _CalorieItemState();
}

class _CalorieItemState extends State<CalorieItem> {
  var form = GlobalKey<FormState>();

  List macros = CalorieStats.macroData;
  final DateTime _value = DateTime.now();
  DateTime today = DateTime.now();
  double servingSize = 0;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: const Color(0xff5FA55A),
        child: _itemCalories(),
      ),
      title: Text(widget.foodTrackEntry.food_name,
          style: const TextStyle(
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

  Widget _itemCalories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(widget.foodTrackEntry.calories.toStringAsFixed(0),
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.white,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w500,
            )),
        const Text('kcal',
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
        SizedBox(
          width: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(CARBS_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                      ' ' +
                          widget.foodTrackEntry.carbs.toStringAsFixed(1) +
                          'g    ',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(PROTEIN_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(
                      ' ' +
                          widget.foodTrackEntry.protein.toStringAsFixed(1) +
                          'g    ',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                  Container(
                    height: 8,
                    width: 8,
                    decoration: const BoxDecoration(
                      color: Color(FAT_COLOR),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text(' ' + widget.foodTrackEntry.fat.toStringAsFixed(1) + 'g',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.black,
                        fontFamily: 'Open Sans',
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
              Text(widget.foodTrackEntry.grams.toString() + 'g',
                  style: const TextStyle(
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
      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 15.0, 0.0),
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
        const Text('% of total',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
              fontFamily: 'Open Sans',
              fontWeight: FontWeight.w400,
            )),
        IconButton(
            icon: const Icon(Icons.edit, color: Colors.black),
            iconSize: 16,
            onPressed: () async {
              _editFoodToAdd(context);
              print("Edit button pressed");
            }),
        IconButton(
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            iconSize: 16,
            onPressed: () async {
              print("Delete button pressed");
              CalorieService.instance()
                  .deleteCalorie(widget.foodTrackEntry.id!);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
      padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: caloriesValue,
              backgroundColor: const Color(0xffEDEDED),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xff5FA55A)),
            ),
          ),
          Text('      ' + ((caloriesValue) * 100).toStringAsFixed(0) + '%',
              style: const TextStyle(
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
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: carbsValue,
              backgroundColor: const Color(0xffEDEDED),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xffFA5457)),
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
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: proteinValue,
              backgroundColor: const Color(0xffEDEDED),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xffFA8925)),
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
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 10.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            height: 10.0,
            width: 200.0,
            child: LinearProgressIndicator(
              value: (widget.foodTrackEntry.fat / macros[3]),
              backgroundColor: const Color(0xffEDEDED),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xff01B4BC)),
            ),
          ),
          Text('      ' + ((fatValue) * 100).toStringAsFixed(0) + '%'),
        ],
      ),
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
            title: const Text('Edit Food '),
            content: _editAmountHad(),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context), // passing false
                child: const Text('Cancel'),
              ),
              FlatButton(
                onPressed: () async {
                  if (checkFormValid()) {
                    Navigator.pop(context);
                    CalorieService.instance().updateCalorie({
                      'food_name': widget.foodTrackEntry.food_name,
                      'calories': widget.foodTrackEntry.calories,
                      'carbs': widget.foodTrackEntry.carbs,
                      'fat': widget.foodTrackEntry.fat,
                      'protein': widget.foodTrackEntry.protein,
                      'mealTime': widget.foodTrackEntry.mealTime,
                      'createdOn': widget.foodTrackEntry.createdOn,
                      'grams': widget.foodTrackEntry.grams
                    }, widget.foodTrackEntry.id!);
                    form.currentState!.reset();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Food Updated Successfully'),
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
      child: Column(
        children: [
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
              if (int.tryParse(value) == null) {
                widget.foodTrackEntry.calories = 0;
              } else {
                widget.foodTrackEntry.calories = int.parse(value);
              }
            },
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
              if (int.tryParse(value) == null) {
                widget.foodTrackEntry.carbs = 0;
              } else {
                widget.foodTrackEntry.carbs = int.parse(value);
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
              if (int.tryParse(value) == null) {
                widget.foodTrackEntry.protein = 0;
              } else {
                widget.foodTrackEntry.protein = int.parse(value);
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
              if (int.tryParse(value) == null) {
                widget.foodTrackEntry.fat = 0;
              } else {
                widget.foodTrackEntry.fat = int.parse(value);
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
              if (int.tryParse(value) == null) {
                widget.foodTrackEntry.grams = 0;
              } else {
                widget.foodTrackEntry.grams = int.parse(value);
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
            value: widget.foodTrackEntry.mealTime,
            validator: (value) {
              if (value == null) {
                return "Please provide a mealtime";
              } else {
                return null;
              }
            },
            onChanged: (value) {
              widget.foodTrackEntry.mealTime = value as String;
            },
          )
        ],
      ),
    );
  }
}
