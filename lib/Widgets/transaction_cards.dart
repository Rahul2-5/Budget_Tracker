// ignore_for_file: deprecated_member_use

import 'package:budget_tracker/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class TransactionCard extends StatelessWidget {
   TransactionCard({
    super.key,required this.data,
  });
  final dynamic data;
  var appIcons  = AppIcons();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(data['timestamp']);
    String formatedDate = DateFormat('d MMM hh:mma').format(date);


    return Padding(
      padding: const EdgeInsets.symmetric(vertical:8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 10),
              // ignore: deprecated_member_use
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10.0,
              spreadRadius: 6.0
            )
          ]
        ),
        child: ListTile(
          minVerticalPadding: 12,
          contentPadding:  EdgeInsets.symmetric(horizontal: 10 , vertical: 0),
          leading: Container(
            width: 70,
            height: 110,
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: data['type'] == 'credit' 
                ? Colors.green.withOpacity(0.2) 
                :  Colors.red.withOpacity(0.2),
              ),
            
              child: Center(
                child: FaIcon(appIcons.getExpenseCategoryIcons('${data['category']}'),
               color: data['type'] == 'credit' 
                ? Colors.green.withOpacity(0.9) 
                :  Colors.red.withOpacity(0.9),
              ),
              ),
              
            ),
          ),
          title: Row(
            children: [
              Text("${data['title']}"),
              Spacer(),
              Text(
                "${data['type'] == 'credit' ? '+' : '-'} ₹${data['amount']}",
                  style: TextStyle( color: data['type'] == 'credit' 
                ? Colors.green.withOpacity(0.9) 
                :  Colors.red.withOpacity(0.9),)),
            ],
          ),
          subtitle: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text("Balance"),
                  Spacer(),
                  Text(
                    "₹ ${data["remainingAmount"]}",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  )
                ],
              ),
              Text(formatedDate, style: TextStyle(color: Colors.grey), )
            ],
          ),
        ),
      ),
    );
  }
}
