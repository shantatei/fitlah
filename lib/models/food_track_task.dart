import 'package:firebase_database/firebase_database.dart';

class FoodTrackTask {
  String email;
  String food_name;
  num calories;
  num carbs;
  num fat;
  num protein;
  String mealTime;
  DateTime createdOn;
  num grams;

  FoodTrackTask({
    required this.email,
    required this.food_name,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    required this.mealTime,
    required this.createdOn,
    required this.grams,
  });

  factory FoodTrackTask.fromSnapshot(DataSnapshot snap) => FoodTrackTask(
      email: snap.child('email').value as String,
      food_name: snap.child('food_name').value as String,
      calories: snap.child('calories') as int,
      carbs: snap.child('carbs').value as int,
      fat: snap.child('fat').value as int,
      protein: snap.child('protein').value as int,
      mealTime: snap.child('mealTime').value as String,
      grams: snap.child('grams').value as int,
      createdOn: snap.child('createdOn').value as DateTime);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'mealTime': mealTime,
      'food_name': food_name,
      'calories': calories,
      'carbs': carbs,
      'protein': protein,
      'fat': fat,
      'grams': grams,
      'createdOn': createdOn
    };
  }

}
