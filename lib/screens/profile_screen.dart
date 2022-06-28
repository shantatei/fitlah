import 'package:fitlah/providers/goals_provider.dart';
import 'package:fitlah/screens/edit_profile_screen.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/profile_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var form = GlobalKey<FormState>();

  int? waterintake;

  int? caloriesintake;

  int? steps;

  @override
  Widget build(BuildContext context) {
    GoalsProvider goalsList = Provider.of<GoalsProvider>(context);

    _editGoals(int i, GoalsProvider goals) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Edit Calores Goal '),
              content: Form(
                key: form,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue:
                          goals.getCaloriesIntakeGoals().toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: "Calories Goal (kcal)",
                        hintText: "Please enter your Calories Intake Goal",
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Calories Intake  Goal";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        caloriesintake = int.parse(value);
                      },
                    ),
                    TextFormField(
                      initialValue:
                          goals.getWaterIntakeGoals().toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: "Water Intake Goal (ml)",
                        hintText: "Please enter your Water Intake Goal",
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Water Intake Goal";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        waterintake = int.parse(value);
                      },
                    ),
                    TextFormField(
                      initialValue: goals.getStepsGoals().toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: "Steps (m)",
                        hintText: "Please enter your Steps Goal",
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Steps Goal";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        steps = int.parse(value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () => Navigator.pop(context), // passing false
                  child: Text('Cancel'),
                ),
                FlatButton(
                    onPressed: () {
                      bool isValid = form.currentState!.validate();
                      if (isValid) {
                        form.currentState!.save();

                        goals.updateGoals(
                            waterintake, i, caloriesintake, steps);

                        // Hide the keyboard
                        FocusScope.of(context).unfocus();
                        // Resets the form
                        form.currentState!.reset();

                        //Exiting Form
                        Navigator.of(context).pop();

                        // Shows a SnackBar
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Goals Updated Successfully!'),
                        ));
                      }
                    },
                    child: Text('Ok'))
              ],
            );
          });
    }

    return ListView(
      physics: BouncingScrollPhysics(),
      children: [
        ProfileWidget(
          //use user imagepath ltr*
          imagePath:
              'https://media.istockphoto.com/photos/portrait-of-a-handsome-black-man-picture-id1289461335?b=1&k=20&m=1289461335&s=170667a&w=0&h=7L30Sh0R-0JXjgqFnxupL9msH5idzcz0xZUAMB9hY_k=',
          onClicked: () async {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => EditProfile()));
          },
        ),
        const SizedBox(height: 24),
        buildInfo("55kg", "26 y.o", "165cm"),
        const SizedBox(height: 24),
        Center(
          child: Container(
            width: 250,
            height: 270,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                border: Border.all(
                  color: Colors.black,
                )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Goals",
                        style: CustomTextStyle.metricTextStyle2,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          _editGoals(0, goalsList);
                        },
                        icon: Icon(Icons.edit))
                  ],
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.bolt,
                    color: Colors.orange,
                  ),
                  title: Text(
                    "Calories",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  subtitle: Text(
                    goalsList.getCaloriesIntakeGoals().toStringAsFixed(0),
                    style: CustomTextStyle.metricTextStyle2,
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.droplet,
                    color: themeColor,
                  ),
                  title: Text(
                    "Water",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  subtitle: Text(
                    goalsList.getWaterIntakeGoals().toStringAsFixed(0),
                    style: CustomTextStyle.metricTextStyle2,
                  ),
                ),
                ListTile(
                  leading: FaIcon(
                    FontAwesomeIcons.shoePrints,
                    color: Colors.red,
                  ),
                  title: Text(
                    "Steps",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
                  ),
                  subtitle: Text(
                    goalsList.getStepsGoals().toStringAsFixed(0),
                    style: CustomTextStyle.metricTextStyle2,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget buildInfo(String weight, String age, String height) {
    return Center(
      child: Column(
        children: [
          Text(
              //use user fullname later *
              "Robert",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Weight",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                Text("Age",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                Text("Height",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.normal))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(weight,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(age,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text(height,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
