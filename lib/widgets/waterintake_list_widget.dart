import 'package:fitlah/models/water_intake_task.dart';
import 'package:fitlah/utils/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class WaterintakeList extends StatelessWidget {
  List<WaterIntakeTask> waterIntakeTask;
  Function removeItem;

  WaterintakeList(this.waterIntakeTask, this.removeItem);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (ctx, i) {
        return ListTile(
          leading: CircleAvatar(
            child: FaIcon(FontAwesomeIcons.glassWater),
            backgroundColor: themeColor,
          ),
          title: Text(waterIntakeTask[i].water.toStringAsFixed(0)),
          subtitle: Text(
              DateFormat('yyyy-MM-dd').format(waterIntakeTask[i].createdon)),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              removeItem(i);
            },
          ),
        );
      },
      itemCount: waterIntakeTask.length,
      separatorBuilder: (ctx, i) {
        return Divider(height: 3, color: Colors.blueGrey);
      },
    );
  }
}
