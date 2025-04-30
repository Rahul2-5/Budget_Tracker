// ignore_for_file: deprecated_member_use

import 'package:budget_tracker/Screens/add_transaction_form.dart';
import 'package:budget_tracker/Screens/login_screen.dart';
import 'package:budget_tracker/Widgets/hero_card.dart';
import 'package:budget_tracker/Widgets/transaction_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoader = false;

  String username = "User"; //  Username 
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    createOrUpdateUserInFirestore(); //  Save user info if new
    fetchUsername(); //  Fetch username 
  }

  //  Save user data on first login if not already present
  Future<void> createOrUpdateUserInFirestore() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    final docSnapshot = await userDoc.get();

    if (!docSnapshot.exists) {
      final isGoogle = user.providerData.any((info) => info.providerId == 'google.com');

      final userData = {
        'provider': isGoogle ? 'google' : 'email',
        'name': isGoogle ? user.displayName ?? 'User' : null,
        'username': isGoogle ? null : user.email?.split('@')[0] ?? 'User',
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      };

      await userDoc.set(userData);
    }
  }

  //  Function to fetch name or username from Firestore
  Future<void> fetchUsername() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        print("User data: $data"); //  Debug

        String? name;

        if (data.containsKey('name')) {
          name = data['name'];
        } else if (data.containsKey('username')) {
          name = data['username'];
        }

        setState(() {
          username = name != null && name.trim().isNotEmpty ? name : "User";
        });
      }
    } catch (e) {
      print("Error fetching user info: $e");
    }
  }

  //  Logout logic
logOut() async {
  setState(() {
    isLogoutLoader = true;
  });

  await FirebaseAuth.instance.signOut();

  if (mounted) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );
  }

  if (mounted) {
    setState(() {
      isLogoutLoader = false;
    });
  }
}


  _dialogBuilder(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: AddTransactionForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: () {
          _dialogBuilder(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
     appBar: AppBar(
  backgroundColor: Colors.blue.shade900,
  title: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
   mainAxisSize: MainAxisSize.min,
    children: [
      const Text(
        "Hello,",
        style: TextStyle(
          color: Colors.white70,
          fontSize: 23,
        ),
      ),
      Text(
        username,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 23,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    ],
  ),
  actions: [
    IconButton(
      onPressed: logOut,
      icon: isLogoutLoader
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
    )
  ],
),

      body: SingleChildScrollView(
        child: Column(
          children: [
            HeroCard(userId: userId),
            Container(
              color: Colors.white,
              child: TransactionCards(),
            ),
          ],
        ),
      ),
    );
  }
}
