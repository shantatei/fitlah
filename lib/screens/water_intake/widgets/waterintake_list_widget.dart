import 'package:fitlah/models/water.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../services/water_service.dart';

class WaterintakeList extends StatefulWidget {
  @override
  State<WaterintakeList> createState() => _WaterintakeListState();
}

class _WaterintakeListState extends State<WaterintakeList> {
  var form = GlobalKey<FormState>();

  WaterService fsService = WaterService();
  late double waterintake;

  void removeItem(String id) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      fsService.removeWater(id);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  _editWaterIntake(id) {
    return showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder<List<WaterIntakeTask>>(
              stream: fsService.getWater(),
              builder: (context, snapshot) {
                return AlertDialog(
                  title: Text('Edit Water Intake '),
                  content: Form(
                    key: form,
                    child: TextFormField(
                      initialValue: snapshot.data![id].water.toStringAsFixed(0),
                      decoration: const InputDecoration(
                        labelText: "Water Intake (ml)",
                        hintText: "Please enter your Water Intake",
                        errorStyle: TextStyle(color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your Water Intake";
                        }
                        return null;
                      },
                      onChanged: (value) {
                        waterintake = double.parse(value);
                      },
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

                            // setState(() {
                            //   myWaterIntakeTask.editWaterIntake(waterintake, i);
                            // });

                            fsService.editWater(
                                id, waterintake, snapshot.data![id].createdon);

                            // Hide the keyboard
                            FocusScope.of(context).unfocus();
                            // Resets the form
                            form.currentState!.reset();

                            //Exiting Form
                            Navigator.of(context).pop();

                            // Shows a SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content:
                                  Text('Water intake edited successfully!'),
                            ));
                          }
                        },
                        child: Text('Ok'))
                  ],
                );
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    // AllWaterIntake waterintakeList = Provider.of<AllWaterIntake>(context);

    WaterService fsService = WaterService();
    return StreamBuilder<List<WaterIntakeTask>>(
        stream: fsService.getWater(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.separated(
              itemBuilder: (ctx, i) {
                return ExpansionTile(
                  leading: CircleAvatar(
                    child: FaIcon(FontAwesomeIcons.glassWater),
                    backgroundColor: themeColor,
                  ),
                  title:
                      Text(snapshot.data![i].water.toStringAsFixed(0) + " ml"),
                  subtitle: Text(DateFormat('yyyy-MM-dd')
                      .format(snapshot.data![i].createdon)),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          child: Text(
                            "Edit",
                            style: CustomTextStyle.metricTextStyle,
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.green),
                          onPressed: () {
                            _editWaterIntake(snapshot.data![i].id);
                          },
                        ),
                        OutlinedButton(
                          child: Text(
                            "Delete",
                            style: CustomTextStyle.metricTextStyle,
                          ),
                          style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.red),
                          onPressed: () {
                            removeItem(snapshot.data![i].id);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
              itemCount: snapshot.data!.length,
              separatorBuilder: (ctx, i) {
                return Container(
                  width: double.infinity,
                  height: 2,
                  color: Colors.black,
                );
              },
            );
          }
        });
  }
}
