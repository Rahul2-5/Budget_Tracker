import 'package:budget_tracker/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TransactionCards extends StatelessWidget {
   TransactionCards({super.key});

  var appIcons = AppIcons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Row(
            children: [
              Text("Recent Transaction",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          ListView.builder(   
            itemCount: 4,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
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
                        color: Colors.grey.withOpacity(0.09),
                        blurRadius: 10.0,
                        spreadRadius: 4.0
                      )
                    ]
                  ),
                  child: ListTile(
                    minVerticalPadding: 5,
                    contentPadding:  EdgeInsets.symmetric(horizontal: 10 , vertical: 0),
                    leading: Container(
                      width: 70,
                      height: 100,
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.green.withOpacity(0.2),
                        ),
                      
                        child: Center(child: FaIcon(appIcons.getExpenseCategoryIcons('Grocery'))),
                      ),
                    ),
                    title: Row(
                      children: [
                        Text("Car Rent 2023"),
                        Spacer(),
                        Text("₹ 8000",
                            style: TextStyle(color: Colors.green, fontSize: 13)),
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
                              "₹ 525",
                              style: TextStyle(color: Colors.grey, fontSize: 13),
                            )
                          ],
                        ),
                        Text("25 oct 4:51 PM " , style: TextStyle(color: Colors.grey), )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
