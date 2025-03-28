// ignore_for_file: deprecated_member_use

import 'package:budget_tracker/Screens/add_transaction_form.dart';
import 'package:budget_tracker/Screens/login_screen.dart';
import 'package:budget_tracker/Widgets/hero_card.dart';
import 'package:budget_tracker/Widgets/transaction_cards.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLogoutLoader = false;
  logOut() async {
    setState(() {
      isLogoutLoader = true;
    });
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginView()),
    );

    setState(() {
      isLogoutLoader = false;
    });
  }

  _dialogBuilder(BuildContext context){
    return showDialog(context: context,
     builder: (context){
      return AlertDialog(
        content : AddTransactionForm(),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade900,
        onPressed: ((){_dialogBuilder(context);}),
        child: Icon(Icons.add,
        color: Colors.white,),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          "Hello,",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: logOut,
              icon: isLogoutLoader
                  ? CircularProgressIndicator()
                  : Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ))
        ],
      ),
      body: Column(
        children: [
          HeroCard(),
         TransactionCards(),
        ],
      ),
    );
  }
}

