import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitlah/services/auth_service.dart';

import '../models/run.dart';

class RunService {
  RunService._();
  static final RunService _instance = RunService._();
  factory RunService.instance() => _instance;

  final AuthService authService = AuthService();
  final FirebaseFirestore fbstore = FirebaseFirestore.instance;
  final Reference _reference = FirebaseStorage.instance.ref();

  Stream<List<Run>> getRunList() {
    return fbstore
        .collection('runs')
        .where('email', isEqualTo: authService.getCurrentUser()!.email)
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((document) => Run.fromMap(document)).toList(),
        );
  }

  Future<bool> addRun(
    Run run,
    Uint8List runImage,
  ) async {
    try {
      await _reference.child(run.runImage).putData(runImage);
      await fbstore.collection('runs').doc(run.id).set({
        'email': run.email,
        'runImage': run.runImage,
        'date': run.date,
        'duration': run.duration,
        'distance': run.distance,
        'speed': run.speed,
      });
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteRun(List<String> idList) async {
    try {
      WriteBatch batch = fbstore.batch();
      for (String id in idList) {
        DocumentSnapshot<Map<String, dynamic>> document =
            await fbstore.collection('runs').doc(id).get();
        await _reference.child(document["runImage"]).delete();
        batch.delete(document.reference);
      }
      await batch.commit();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<bool> deleteAllRuns() async {
    try {
      QuerySnapshot<Map<String, dynamic>> allRuns = await fbstore
          .collection('runs')
          .where('email', isEqualTo: authService.getCurrentUser()!.email)
          .get();
      WriteBatch batch = fbstore.batch();
      for (var doc in allRuns.docs) {
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
