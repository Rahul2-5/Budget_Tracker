import 'package:budget_tracker/Screens/Dashboard.dart';
import 'package:budget_tracker/Screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>
(stream: FirebaseAuth.instance.authStateChanges(),
     builder: (context , snapshot){
      if(!snapshot.hasData){
        return LoginView();
      }
      return Dashboard();
     }
     );
  }
}