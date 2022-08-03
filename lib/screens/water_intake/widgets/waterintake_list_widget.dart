import 'package:fitlah/models/water.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../../../services/water_service.dart';

class WaterintakeList extends StatefulWidget {
  final List<WaterIntakeTask> waterList;

  const WaterintakeList({Key? key, required this.waterList}) : super(key: key);
  @override
  State<WaterintakeList> createState() => _WaterintakeListState();
}

class _WaterintakeListState extends State<WaterintakeList> {
  var form = GlobalKey<FormState>();

  late double waterintake;

  void removeItem(String id) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Are you sure you want to delete?'),
          actions: [
            TextButton(
                onPressed: () {
                  setState(
                    () {
                      WaterService.instance().removeWater(id);
                    },
                  );
                  Navigator.of(context).pop();
                },
                child: const Text('Yes')),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  _editWaterIntake(index, id) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Water Intake '),
          content: Form(
            key: form,
            child: TextFormField(
              initialValue: widget.waterList[index].water.toStringAsFixed(0),
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
                if (double.tryParse(value) == null) {
                  waterintake = 0;
                } else {
                  waterintake = double.parse(value);
                }
              },
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.pop(context), // passing false
              child: const Text('Cancel'),
            ),
            FlatButton(
                onPressed: () {
                  bool isValid = form.currentState!.validate();
                  if (isValid) {
                    form.currentState!.save();

                    WaterService.instance().editWater(
                        id, waterintake, widget.waterList[index].createdon);

                    // Hide the keyboard
                    FocusScope.of(context).unfocus();
                    // Resets the form
                    form.currentState!.reset();

                    //Exiting Form
                    Navigator.of(context).pop();

                    // Shows a SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Water intake edited successfully!'),
                      ),
                    );
                  }
                },
                child: const Text('Ok'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ExpansionTile(
          leading: const CircleAvatar(
            child: FaIcon(FontAwesomeIcons.glassWater),
            backgroundColor: themeColor,
          ),
          title: Text(widget.waterList[i].water.toStringAsFixed(0) + " ml"),
          subtitle: Text(
            DateFormat('yyyy-MM-dd').format(widget.waterList[i].createdon),
          ),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  child: const Text(
                    "Edit",
                    style: CustomTextStyle.metricTextStyle,
                  ),
                  style:
                      OutlinedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () {
                    _editWaterIntake(i, widget.waterList[i].id);
                  },
                ),
                OutlinedButton(
                  child: const Text(
                    "Delete",
                    style: CustomTextStyle.metricTextStyle,
                  ),
                  style: OutlinedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    removeItem(widget.waterList[i].id);
                  },
                ),
              ],
            ),
          ],
        );
      },
      itemCount: widget.waterList.length,
      separatorBuilder: (ctx, i) {
        return Container(
          width: double.infinity,
          height: 2,
          color: Colors.black,
        );
      },
    );
  }
}
