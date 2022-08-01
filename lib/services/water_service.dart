import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/services/auth_service.dart';

import '../models/water.dart';

class WaterService {
  AuthService authService = AuthService();

  addWater(water, createdon) {
    return FirebaseFirestore.instance.collection('water').add({
      'email': authService.getCurrentUser()!.email,
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
        .where('email', isEqualTo: authService.getCurrentUser()!.email)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map<WaterIntakeTask>(
                (doc) => WaterIntakeTask.fromMap(doc.data(), doc.id))
            .toList());
  }

  editWater(id, water, createdon) {
    return FirebaseFirestore.instance.collection('water').doc(id).set({
      'water': water,
      'createdon': createdon,
    });
  }
}
