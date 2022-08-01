import 'package:fitlah/screens/calories_intake/widgets/calorie_item_widget.dart';
import 'package:flutter/material.dart';

import '../../../models/calorie.dart';

class CalorieList extends StatelessWidget {
  final AsyncSnapshot<List<Calorie>> caloriesnapshot;
  const CalorieList({Key? key, required this.caloriesnapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: caloriesnapshot.data!.length + 1,
      itemBuilder: (context, index) {
        if (index < caloriesnapshot.data!.length) {
          return CalorieItem(foodTrackEntry: caloriesnapshot.data![index]);
        } else {
          return const SizedBox(height: 5);
        }
      },
    );
  }

}
