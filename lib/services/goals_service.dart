import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitlah/models/goals.dart';
import 'package:fitlah/services/auth_service.dart';
import 'package:uuid/uuid.dart';

class GoalService {
  GoalService._();
  static final GoalService _instance = GoalService._();
  factory GoalService.instance() => _instance;

  final AuthService authService = AuthService();

  // setGoal() {
  //   return FirebaseFirestore.instance.collection('goals').doc().set({
  //     'email': authService.getCurrentUser()!.email,
  //     'waterintake': 2000,
  //     'caloriesintake': 2000,
  //     'steps': 10000
  //   });
  // }

  Stream<List<Goals>> getGoal() {
    return FirebaseFirestore.instance
        .collection('goals')
        .where('email', isEqualTo: authService.getCurrentUser()!.email)
        .snapshots()
        .map(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          return [
            Goals(
              id: const Uuid().v4(),
              email: authService.getCurrentUser()!.email!,
              waterintake: 2000,
              caloriesintake: 2000,
              steps: 10000,
            )
          ];
        }
        return snapshot.docs.map<Goals>((doc) {
          print(doc.exists);
          int waterintake = 2000;
          int caloriesintake = 2000;
          int steps = 10000;
          if (doc.exists) {
            if (doc["waterintake"] != null &&
                doc["waterintake"] != waterintake) {
              waterintake = doc["waterintake"];
            }
            if (doc["caloriesintake"] != null &&
                doc["caloriesintake"] != caloriesintake) {
              caloriesintake = doc["caloriesintake"];
            }
            if (doc["steps"] != null && doc["steps"] != steps) {
              steps = doc["steps"];
            }
          }
          return Goals(
            id: doc.id,
            email: authService.getCurrentUser()!.email!,
            waterintake: waterintake,
            caloriesintake: caloriesintake,
            steps: steps,
          );
        }).toList();
      },
    );
  }

  updateGoal(id, waterintake, caloriesintake, steps) {
    return FirebaseFirestore.instance.collection('goals').doc(id).set({
      'email': authService.getCurrentUser()!.email!,
      'waterintake': waterintake,
      'caloriesintake': caloriesintake,
      'steps': steps
    });
  }
}
