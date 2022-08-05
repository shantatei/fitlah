import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/models/calorie.dart';
import 'package:fitlah/services/auth_service.dart';

class CalorieService {
  CalorieService._();
  static final CalorieService _instance = CalorieService._();
  factory CalorieService.instance() => _instance;

  final FirebaseFirestore fbstore = FirebaseFirestore.instance;
  final String collectionName = 'foodTracks';
  final AuthService authService = AuthService();

  Stream<List<Calorie>> getCalorieList() {
    return fbstore
        .collection(collectionName)
        .where('email', isEqualTo: authService.getCurrentUser()!.email!)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map(
        (snap) {
          return Calorie.fromSnapshot(snap);
        },
      ).toList();
    });
  }

  Future insertCalorie(Calorie food) async {
    await fbstore.collection(collectionName).doc().set(
          food.toMap(),
        );
  }

  Future updateCalorie(Map<String, dynamic> updateValues, String id) async {
    await fbstore.collection(collectionName).doc(id).update(updateValues);
  }

  Future deleteCalorie(String id) async {
    await fbstore.collection(collectionName).doc(id).delete();
  }

  Stream<List<Calorie>> getCaloriebyDate(DateTime selectedDate) async* {
    var dateSelected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    var stream = fbstore
        .collection(collectionName)
        .where('email', isEqualTo: authService.getCurrentUser()!.email!)
        .snapshots();

    await for (var snapshot in stream) {
      List<Calorie> calorieList = [];
      for (var doc in snapshot.docs) {
        Calorie calorie = Calorie.fromSnapshot(doc);
        DateTime scanDate = DateTime(
          calorie.createdOn.year,
          calorie.createdOn.month,
          calorie.createdOn.day,
        );
        if (scanDate.compareTo(dateSelected) == 0) {
          calorieList.add(calorie);
        }
      }
      yield calorieList;
    }
  }

  Future<bool> deleteAllCalories() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allCalories = await fbstore
          .collection(collectionName)
          .where('email', isEqualTo: authService.getCurrentUser()!.email!)
          .get();
      WriteBatch batch = fbstore.batch();
      for (var doc in allCalories.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
