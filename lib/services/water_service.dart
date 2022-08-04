import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/services/auth_service.dart';

import '../models/water.dart';

class WaterService {
  WaterService._();
  static final WaterService _instance = WaterService._();
  factory WaterService.instance() => _instance;

  final FirebaseFirestore fbstore = FirebaseFirestore.instance;
  final String email = AuthService().getCurrentUser()!.email!;
  final String collectionName = 'water';

  addWater(water, createdon) {
    return FirebaseFirestore.instance.collection('water').add({
      'email': email,
      'water': water,
      'createdon': createdon,
    });
  }

  removeWater(id) {
    return FirebaseFirestore.instance.collection('water').doc(id).delete();
  }

  Stream<List<WaterIntakeTask>> getWater() {
    return FirebaseFirestore.instance
        .collection('water')
        .where('email', isEqualTo:email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<WaterIntakeTask>(
                (doc) => WaterIntakeTask.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<WaterIntakeTask>> getWaterbyDate(DateTime selectedDate) async* {
    var dateSelected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );
    var stream = fbstore
        .collection(collectionName)
        .where('email', isEqualTo: email)
        .snapshots();

    await for (var snapshot in stream) {
      List<WaterIntakeTask> waterList = [];
      for (var doc in snapshot.docs) {
        WaterIntakeTask water = WaterIntakeTask.fromSnapshot(doc);
        DateTime scanDate = DateTime(
          water.createdon.year,
          water.createdon.month,
          water.createdon.day,
        );
        if (scanDate.compareTo(dateSelected) == 0) {
          waterList.add(water);
        }
      }
      yield waterList;
    }
  }

  editWater(id, water, createdon) {
    return FirebaseFirestore.instance.collection('water').doc(id).set({
      'email': email,
      'water': water,
      'createdon': createdon,
    });
  }

  
   Future<bool> deleteAllWater() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allWater= await fbstore
          .collection(collectionName)
          .where('email', isEqualTo: email)
          .get(); 
      WriteBatch batch = fbstore.batch();
      for (var doc in allWater.docs) {
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
