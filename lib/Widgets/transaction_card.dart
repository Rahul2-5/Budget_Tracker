import 'package:budget_tracker/Widgets/transaction_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TransactionCards extends StatelessWidget {
  TransactionCards({super.key});

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
          RecenttransactionList(),
        ],
      ),
    );
  }
}

class RecenttransactionList extends StatelessWidget {
  RecenttransactionList({
    super.key,
  });
  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection("transactions")
            .orderBy('timestamp', descending: false)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          }
          var data = snapshot.data!.docs;

          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              var cardData = data[index];
              var docId = cardData.id;

              return Dismissible(
                key: Key(docId),
                direction: DismissDirection.endToStart, // swipe left to delete
                background: Container(
                  height:
                      80, // Adjust height to match card height or make dynamic later
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.deepOrange],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.delete, color: Colors.white, size: 28),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                onDismissed: (direction) async {
                  try {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .collection("transactions")
                        .doc(docId)
                        .delete();

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Transaction deleted'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.redAccent,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete: $e')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TransactionCard(data: cardData),
                ),
              );
            },
          );
        });
  }
}
