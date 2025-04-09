import 'package:budget_tracker/Widgets/category_list.dart';
import 'package:budget_tracker/Widgets/tab_bar_view.dart';
import 'package:budget_tracker/Widgets/time_line_month.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionScreen extends StatefulWidget {
 TransactionScreen({super.key,});


  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
    var category = "All";
  String monthYear = "";

  @override
  void initState(){
    DateTime now = DateTime.now();
    setState(() {
      monthYear = DateFormat('MMM y').format(now);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 247),
      appBar: AppBar(
        title: Text("Details"),
        backgroundColor:Color.fromARGB(255, 248, 247, 247),
      ),
      body: Column(
        children: [
          TimeLineMonth(
            onChanged: (String? value) {
             if(value != null){
              setState(() {
                monthYear = value;
              });
              
            }
           },),
          CategoryList(
            onChanged: (String? value){
            if(value != null){
              setState(() {
                 category = value;
              });
             
            }
          }
          ),
          TypeTabBar(category:category , monthYear:monthYear),
        ],
        ),
    );
  }
}
