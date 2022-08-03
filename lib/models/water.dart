import 'package:cloud_firestore/cloud_firestore.dart';

class WaterIntakeTask {
  String id;
  String email;
  double water;
  DateTime createdon;

  WaterIntakeTask({
    required this.email,
    required this.id,
    required this.water,
    required this.createdon,
  });
  
  WaterIntakeTask.fromSnapshot(DocumentSnapshot document)
      : this(
          id: document.id,
          email: document['email'],
          water: document['water'],
          createdon: document['createdon'].toDate(),
        );

  WaterIntakeTask.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id,
        email = snapshot['email'] ?? '',
        water = snapshot['water'] ?? '',
        createdon =
            (snapshot['travelDate'] ?? Timestamp.now() as Timestamp).toDate();
}
