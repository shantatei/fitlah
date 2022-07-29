import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/services/auth_service.dart';

import '../models/position.dart';

class PositionService{
  PositionService._();
  static final PositionService _instance = PositionService._();
  factory PositionService.instance() => _instance;

  final FirebaseFirestore fbstore = FirebaseFirestore.instance;


  Future<List<List<Position>>?> getRunRoute(String runId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fbstore
          .collection('runs')
          .doc(runId)
          .collection('routes')
          .get();
      List<List<Position>> runRoute = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        runRoute.add([]);
        List routePoints = doc['route'];
        for (Map map in routePoints) {
          runRoute.last.add(
            Position.fromMap(
              map as Map<String, dynamic>,
              doc.id,
            ),
          );
        }
      }
      return runRoute;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<bool> addRunRoute(
    List<List<Position>> runRoute,
    String runId,
  ) async {
    try {
      WriteBatch batch = fbstore.batch();
      for (List<Position> positionList in runRoute) {
        List<Map<String, dynamic>> mapList = positionList.map(
          (position) {
            return position.toMap();
          },
        ).toList();
        batch.set(
          fbstore
              .collection('runs')
              .doc(runId)
              .collection('routes')
              .doc(positionList.first.polylineId),
          {
            'route': mapList,
          },
        );
      }
      await batch.commit();
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<bool> deleteRunRoute(String runId) async {
    try {
      WriteBatch batch = fbstore.batch();
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await fbstore
          .collection('runs')
          .doc(runId)
          .collection('routes')
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
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