import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/models/food_track_task.dart';
import 'dart:async';

import 'package:fitlah/services/auth_service.dart';

class DatabaseService {
  AuthService authService = AuthService();
  final String uid;
  final DateTime currentDate;
  DatabaseService({required this.uid, required this.currentDate});

  final DateTime today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  final DateTime weekStart = DateTime(2020, 09, 07);
  // collection reference
  final CollectionReference foodTrackCollection = FirebaseFirestore.instance
      .collection('foodTracks'); //db collection name called 'foodtracks'

  //method to create a new record for food diary
  Future addFoodTrackEntry(FoodTrackTask food) async {
    return await foodTrackCollection
        .doc(food.createdOn.millisecondsSinceEpoch.toString())
        .set({
      'email': authService.getCurrentUser()!.email,
      'food_name': food.food_name,
      'calories': food.calories,
      'carbs': food.carbs,
      'fat': food.fat,
      'protein': food.protein,
      'mealTime': food.mealTime,
      'createdOn': food.createdOn,
      'grams': food.grams
    });
  }

  //method to delete a record for food diary
  Future deleteFoodTrackEntry(FoodTrackTask deleteEntry) async {
    return await foodTrackCollection
        //identify by using the checking the millisecondvalue (id)
        .doc(deleteEntry.createdOn.millisecondsSinceEpoch.toString())
        .delete();
  }

  //method to edit a record for food diary
  editFoodTrackEntry(FoodTrackTask editEntry) {
    return foodTrackCollection
        .doc(editEntry.createdOn.millisecondsSinceEpoch.toString())
        .update({
      'food_name': editEntry.food_name,
      'calories': editEntry.calories,
      'carbs': editEntry.carbs,
      'fat': editEntry.fat,
      'protein': editEntry.protein,
      'mealTime': editEntry.mealTime,
      'createdOn': editEntry.createdOn,
      'grams': editEntry.grams
    });
  }

  //converting data from firestore (array format)
  //mapping it and converting into FoodTrackTask Object
  //converting object to a list
  List<FoodTrackTask> _foodTrackListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return FoodTrackTask(
        email: doc['email'] ?? '',
        food_name: doc['food_name'] ?? '',
        calories: doc['calories'] ?? 0,
        carbs: doc['carbs'] ?? 0,
        fat: doc['fat'] ?? 0,
        protein: doc['protein'] ?? 0,
        mealTime: doc['mealTime'] ?? "",
        createdOn: doc['createdOn'].toDate() ?? DateTime.now(),
        grams: doc['grams'] ?? 0,
      );
    }).toList();
  }

  //converted to list
  Stream<List<FoodTrackTask>> get foodTracks {
    return foodTrackCollection
        .where('email', isEqualTo: authService.getCurrentUser()!.email)
        .snapshots()
        .map(_foodTrackListFromSnapshot);
  }


  //getting a specific food track record using uid
  Future<String> getFoodTrackData(String uid) async {
    DocumentSnapshot snapshot = await foodTrackCollection.doc(uid).get();
    return snapshot.toString();
  }
}