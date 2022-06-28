import 'package:flutter/material.dart';
import '../models/goals.dart';

class GoalsProvider with ChangeNotifier {
  List<Goals> goalsList = [
    Goals(waterintake: 1920, caloriesintake: 2000, steps: 7000)
  ];

  List<Goals> getMyGoals() {
    return goalsList;
  }

  int getWaterIntakeGoals() {
    int waterintakes = 0;

    for (var element in goalsList) {
      waterintakes = element.waterintake;
    }

    return waterintakes;
  }

  int getCaloriesIntakeGoals() {
    int caloriesintakes = 0;

    for (var element in goalsList) {
      caloriesintakes = element.caloriesintake;
    }

    return caloriesintakes;
  }

  int getStepsGoals() {
    int stepsgoal = 0;

    for (var element in goalsList) {
      stepsgoal = element.steps;
    }

    return stepsgoal;
  }

  void updateGoals( newWater, int i,  newCalories,  newSteps) {
    // goalsList[i].waterintake = newWater;
    // goalsList[i].caloriesintake = newCalories;
    // goalsList[i].steps = newSteps;
    for (var element in goalsList) {
      element.caloriesintake = newCalories;
      element.waterintake = newWater;
      element.steps = newSteps;
    }
    notifyListeners();
  }
}
