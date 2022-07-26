import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String username;
  String email;
  double height;
  double weight;
  int age;
  String? profileImage;

  UserModel({
    required this.username,
    required this.email,
    required this.height,
    required this.weight,
    required this.age,
    this.profileImage,
  });
  UserModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
    String? profileImage,
  ) : this(
          username: document["username"] ?? '',
          email: document.id,
          height: document["height"] ?? 0.0,
          weight: document["weight"] ?? 0.0,
          age: document["age"] ?? 0.0,
          profileImage: profileImage,
        );
}
