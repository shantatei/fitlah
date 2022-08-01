import 'package:cloud_firestore/cloud_firestore.dart';

class Calorie {
  String? id;
  String email;
  String food_name;
  num calories;
  num carbs;
  num fat;
  num protein;
  String mealTime;
  DateTime createdOn;
  num grams;

  Calorie({
    this.id,
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

  Calorie.fromSnapshot(DocumentSnapshot document)
      : this(
          id: document.id,
          email: document['email'],
          food_name: document['food_name'],
          calories: document['calories'],
          carbs: document['carbs'],
          fat: document['fat'],
          protein: document['protein'],
          mealTime: document['mealTime'],
          grams: document['grams'],
          createdOn: document['createdOn'].toDate(),
        );

  Map<String, dynamic> toMap() => {
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
