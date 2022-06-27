import 'package:fitlah/models/water_intake_task.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/all_water_intake.dart';

class WaterintakeList extends StatefulWidget {
  // List<WaterIntakeTask> waterIntakeTask;
  // Function removeItem;

  // WaterintakeList(this.waterIntakeTask, this.removeItem);

  @override
  State<WaterintakeList> createState() => _WaterintakeListState();
}

class _WaterintakeListState extends State<WaterintakeList> {
  void removeItem(int i, AllWaterIntake myWaterIntakeTask) {
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
                      myWaterIntakeTask.removeWaterIntake(i);
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

  @override
  Widget build(BuildContext context) {
    AllWaterIntake waterintakeList = Provider.of<AllWaterIntake>(context);

    return Container(
      decoration:
          BoxDecoration(border: Border.all(color: Colors.black, width: 2)),
      child: ListView.separated(
        itemBuilder: (ctx, i) {
          return ListTile(
            leading: CircleAvatar(
              child: FaIcon(FontAwesomeIcons.glassWater),
              backgroundColor: themeColor,
            ),
            title: Text(
                waterintakeList.getMyWaterIntake()[i].water.toStringAsFixed(0) +
                    " ml"),
            subtitle: Text(DateFormat('yyyy-MM-dd')
                .format(waterintakeList.getMyWaterIntake()[i].createdon)),
            trailing: IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () {
                removeItem(i, waterintakeList);
              },
            ),
          );
        },
        itemCount: waterintakeList.getMyWaterIntake().length,
        separatorBuilder: (ctx, i) {
          return Container(
            width: double.infinity,
            height: 2,
            color: Colors.black,
          );
        },
      ),
    );
  }
}
