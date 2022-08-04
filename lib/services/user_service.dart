import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitlah/models/user.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:fitlah/services/calories_service.dart';
import 'package:fitlah/services/goals_service.dart';
import 'package:fitlah/services/run_service.dart';
import 'package:fitlah/services/water_service.dart';
import 'package:uuid/uuid.dart';

class UserService {
  UserService._();
  static final UserService _instance = UserService._();
  factory UserService.instance() => _instance;

  final AuthService authService = AuthService();
  final FirebaseFirestore fbstore = FirebaseFirestore.instance;
  final Reference _reference = FirebaseStorage.instance.ref();

  Future<UserModel?> getUser() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> document = await fbstore
          .collection('users')
          .doc(authService.getCurrentUser()!.email)
          .get();
      if (_docChecker(document)) return null;
      return Future.value(UserModel.fromDocument(
        document,
        await _getProfileImageUrl(document),
      ));
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  Stream<UserModel?> getUserStream() {
    return fbstore
        .collection('users')
        .doc(authService.getCurrentUser()!.email)
        .snapshots()
        .asyncMap(
      (doc) async {
        if (_docChecker(doc)) return null;
        return UserModel.fromDocument(
          doc,
          await _getProfileImageUrl(doc),
        );
      },
    );
  }

  Future<bool> addUser(UserModel user) async {
    try {
      Map<String, dynamic> map = {
        "username": user.username,
        "height": user.height,
        "weight": user.weight,
        "age": user.age,
      };
      await fbstore.collection('users').doc(user.email).set(map);
      return Future.value(true);
    } catch (e) {
      log(e.toString());
      return Future.value(false);
    }
  }

  Future<bool> updateUser(
    Map<String, dynamic> map,
    File? profileImage,
  ) async {
    try {
      if (profileImage != null) {
        String fileName =
            "profile/${authService.getCurrentUser()!.email}-${const Uuid().v4()}";
        await _reference.child(fileName).putFile(profileImage);
        map["profileImage"] = fileName;
        var doc = await fbstore
            .collection('users')
            .doc(authService.getCurrentUser()!.email)
            .get();
        if (doc.data()!.containsKey('profileImage')) {
          _reference.child(doc["profileImage"]).delete();
        }
      }
      await fbstore
          .collection('users')
          .doc(authService.getCurrentUser()!.email)
          .update(map);
      return Future.value(true);
    } catch (e) {
      log(e.toString());
      return Future.value(false);
    }
  }

  Future<bool> deleteUser() async {
    try {
      await CalorieService.instance().deleteAllCalories();
      await WaterService.instance().deleteAllWater();
      await GoalService.instance().deleteGoal();
      await RunService.instance().deleteAllRuns();
      await fbstore
          .collection('users')
          .doc(authService.getCurrentUser()!.email)
          .delete();
      await authService.getCurrentUser()!.delete();
      return Future.value(true);
    } catch (e) {
      log(e.toString());
      return Future.value(false);
    }
  }

  Future<bool> deleteUserImage() async {
    try {
      String email = authService.getCurrentUser()!.email!;
      var doc = await fbstore.collection('users').doc(email).get();
      if (doc.exists && doc.data()!.containsKey('profileImage')) {
        await _reference.child(doc['profileImage']).delete();
        await fbstore.collection('users').doc(email).update({
          'profileImage': FieldValue.delete(),
        });
      }
      return Future.value(true);
    } catch (e) {
      log(e.toString());
      return Future.value(false);
    }
  }

  bool _docChecker(DocumentSnapshot<Map<String, dynamic>> document) {
    return !document.exists ||
        !document.data()!.containsKey('username') ||
        !document.data()!.containsKey('height') ||
        !document.data()!.containsKey('age') ||
        !document.data()!.containsKey('weight');
  }

  Future<String?> _getProfileImageUrl(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) async {
    if (!document.data()!.containsKey('profileImage')) return null;
    return (await _reference.child(document['profileImage']).getDownloadURL());
  }
}
