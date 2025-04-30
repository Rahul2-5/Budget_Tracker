import 'package:budget_tracker/Screens/Dashboard.dart';
import 'package:budget_tracker/services/db.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final Db _db = Db();
  final FirebaseAuth _auth = FirebaseAuth.instance;

 Future<void> loginWithGoogle(BuildContext context) async {
  try {
    // Force account picker
    await GoogleSignIn().signOut();

    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      print("Google sign-in was cancelled by the user.");
      return;
    }

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    // Firebase sign-in
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final user = userCredential.user;
    if (user == null) throw Exception("User is null after Google sign-in");

    //  Check if user exists in Firestore
    final userDoc = await _db.getUser(user.uid);
    if (!userDoc.exists) {
      // 📝 Create new user entry in Firestore
      await _db.addUser({
        "email": user.email,
        "name": user.displayName,
        "photoUrl": user.photoURL,
        "createdAt": DateTime.now().toIso8601String(),
        "provider": "google",
        
      }, user.uid);

      print(" Google user added to Firestore.");
    }

    //  Navigate to Dashboard
    if (context.mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  } catch (e) {
    print(" Google login failed: $e");
    _showErrorDialog(context, "Google Login Error", e.toString());
  }
}




  Future<void> createUser(Map<String, dynamic> data, BuildContext context) async {
    try {
      String email = data['email'].trim();
      String password = data['password'].trim();

      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user!.uid;

      // Debugging: Print user ID to console
      print("User Created: $userId");

      // Add user data to Firestore
      await _db.addUser(data, userId);

      print("User added to Firestore!");

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    } catch (e) {
      print("Error: $e");
      _showErrorDialog(context, "Sign-up Failed", e.toString());
    }
  }

  Future<void> login(Map<String, dynamic> data, BuildContext context) async {
    try {
      String email = data['email'].trim();
      String password = data['password'].trim();

      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("User Logged In!");

      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      }
    } catch (e) {
      print("Login Error: $e");
      _showErrorDialog(context, "Login Error", e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent),
            SizedBox(width: 10),
            Text(title),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK", style: TextStyle(color: Colors.redAccent)),
          )
        ],
      );
    },
  );
}
   

}
