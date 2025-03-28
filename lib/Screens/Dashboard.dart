import 'package:budget_tracker/Screens/home_screen.dart';

import 'package:budget_tracker/Screens/transaction_screen.dart';
import 'package:budget_tracker/Widgets/navbar.dart';

import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var isLogoutLoader = false;
   int currentIndex = 0;

   var pageViewList = [
    HomeScreen(),
    TransactionScreen(),
   ];

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Navbar(
        selectedIndex: currentIndex,
       onDestinationSelected: (int value){
        setState(() {
          currentIndex = value;
        });
        
       }),
     
      body: pageViewList[currentIndex],
    );
  }
}
