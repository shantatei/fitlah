import 'package:flutter/material.dart';
import '../models/water_intake_task.dart';

class AllWaterIntake with ChangeNotifier {
  List<WaterIntakeTask> myWaterIntake = [];

  List<WaterIntakeTask> getMyWaterIntake() {
    return myWaterIntake;
  }

  void addWaterIntake(water, createdon) {
    myWaterIntake.insert(
        0,
        WaterIntakeTask(
          water: water,
          createdon: createdon,
        ));
    notifyListeners();
  }

  void removeWaterIntake(i) {
    myWaterIntake.removeAt(i);
    notifyListeners();
  }

  getSpecificWaterIntake(i) {
    return myWaterIntake[i];
  }

  double getTotalWater() {
    double sum = 0;
    myWaterIntake.forEach((element) {
      sum += element.water;
    });

    return sum;
  }
}
