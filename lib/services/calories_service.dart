import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/models/calorie.dart';
import 'package:fitlah/services/auth_service.dart';

class CalorieService {
  CalorieService._();
  static final CalorieService _instance = CalorieService._();
  factory CalorieService.instance() => _instance;

  final FirebaseFirestore fbstore = FirebaseFirestore.instance;
  final String email = AuthService().getCurrentUser()!.email!;
  final String collectionName = 'foodTracks';

  Stream<List<Calorie>> getCalorieList() {
    return fbstore
        .collection(collectionName)
        .where('email', isEqualTo: email)
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

  Future<List<Calorie>> getCaloriebyDate(DateTime selectedDate) async {
    QuerySnapshot<Map<String, dynamic>> doclist = await fbstore
        .collection(collectionName)
        .where('email', isEqualTo: email)
        .get();
    var list = doclist.docs.map((snapshot) {
      return Calorie.fromSnapshot(snapshot);
    }).toList();
    var dateSelected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    List<Calorie> selectedCalorie = findSelectedCalorie(list, dateSelected);

    return selectedCalorie;
  }

  List<Calorie> findSelectedCalorie(List foodTrackFeed, DateTime dateSelected) {
    List<Calorie> selectedCalorie = [];
    for (var foodTrack in foodTrackFeed) {
      DateTime scanDate = DateTime(foodTrack.createdOn.year,
          foodTrack.createdOn.month, foodTrack.createdOn.day);
      if (scanDate.compareTo(dateSelected) == 0) {
        selectedCalorie.add(foodTrack);
      }
    }
    return selectedCalorie;
  }
}
