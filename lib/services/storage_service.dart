import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  StorageService._internal();
  static final _instance = StorageService._internal();
  factory StorageService.instance() => _instance;

  final Reference _reference = FirebaseStorage.instance.ref();
  

  Future<String> getDownloadUrl(String child) {
    return _reference.child(child).getDownloadURL();
  }
}