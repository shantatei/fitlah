import 'package:cloud_firestore/cloud_firestore.dart';

class Run {
  String id;
  String email;
  String runImage;
  int timestarted;
  int duration;
  double distance;
  double speed;

  Run({
    required this.id,
    required this.email,
    required this.runImage,
    required this.timestarted,
    required this.duration,
    required this.distance,
    required this.speed,
  });

  Run.fromMap(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) : this(
          id: document.id,
          email: document["email"],
          runImage: document["runImage"],
          timestarted: document["timestarted"],
          duration: document["duration"],
          distance: document["distance"],
          speed: document["speed"],
        );
}
