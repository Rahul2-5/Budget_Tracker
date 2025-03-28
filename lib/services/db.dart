import 'package:cloud_firestore/cloud_firestore.dart';

class Db {
  final CollectionReference _users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(Map<String, dynamic> data, String userId) async {
    try {
      // Add createdAt timestamp for debugging
      data['createdAt'] = FieldValue.serverTimestamp();

      // Store user data in Firestore
      await _users.doc(userId).set(data, SetOptions(merge: true));
      
      print("User Data Successfully Added to Firestore");
    } catch (e) {
      print("Error adding user to Firestore: $e");
    }
  }
}
