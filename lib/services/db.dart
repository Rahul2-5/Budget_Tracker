import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // ✅ Add user to Firestore
  Future<void> addUser(Map<String, dynamic> data, String uid) async {
    try {
      await users.doc(uid).set(data);
      print("✅ User added to Firestore");
    } catch (error) {
      print("❌ Failed to add user: $error");
    }
  }

  // ✅ Get user from Firestore
  Future<DocumentSnapshot> getUser(String uid) async {
    return await users.doc(uid).get();
  }
}
