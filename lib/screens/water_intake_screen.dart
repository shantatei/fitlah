import 'package:fitlah/models/water_intake_task.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:fitlah/widgets/waterintake_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WaterIntake extends StatefulWidget {
  @override
  State<WaterIntake> createState() => _WaterIntakeState();
}

class _WaterIntakeState extends State<WaterIntake> {
  var form = GlobalKey<FormState>();

  double? waterintake;
  DateTime? createdon;

  List<WaterIntakeTask> myWaterIntakeTask = [];

  @override
  Widget build(BuildContext context) {
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

    Widget _addWaterButton() {
      return IconButton(
        icon: Icon(Icons.add_box),
        iconSize: 25,
        color: Colors.white,
        onPressed: () async {},
      );
    }

    addWater() {
      bool isValid = form.currentState!.validate();
      if (isValid) {
        form.currentState!.save();
        print(waterintake);

        createdon = DateTime.now().toUtc();

        myWaterIntakeTask.insert(
            0, WaterIntakeTask(water: waterintake!, createdon: createdon!));
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

    // ignore: unused_element
    void removeItem(i) {
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
                        myWaterIntakeTask.removeAt(i);
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _backButton(),
                // _addWaterButton(),
              ],
            ),
          )),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FaIcon(FontAwesomeIcons.minusCircle),
                Image.asset(
                  'images/water_bottle.png',
                  width: 150,
                ),
                FaIcon(FontAwesomeIcons.plusCircle)
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
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        // borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                        // borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      ),
                      contentPadding: EdgeInsets.all(10),
                      hintStyle:
                          TextStyle(fontSize: 14, color: Color(textColor1)),
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
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "1x Glass 240ml",
              style: CustomTextStyle.metricTextStyle2,
            ),
          ),
          OutlinedButton(
            onPressed: addWater,
            child: Text("Add Glasses"),
          ),
          Expanded(
              child: myWaterIntakeTask.length > 0
                  ? Container(
                      height: 200,
                      child: WaterintakeList(myWaterIntakeTask, removeItem),
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
  }
}
