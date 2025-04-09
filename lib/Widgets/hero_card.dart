import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HeroCard extends StatelessWidget {
  HeroCard({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> _usersStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return Cards(data: data);
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.data,
  });

  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue.shade900,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Total Balance",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹ ${data['remainingAmount']}",
                  style: TextStyle(
                    fontSize: 44,
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                /// ✅ Wrapped CardOne in Expanded
                Expanded(
                  child: CardOne(
                    color: Colors.green,
                    heading: 'Credit',
                    amount: "${data['totalCredit']}",
                  ),
                ),
                SizedBox(width: 10),
                /// ✅ Wrapped CardOne in Expanded
                Expanded(
                  child: CardOne(
                    color: Colors.red,
                    heading: 'Debit',
                    amount: "${data['totalDebit']}",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class CardOne extends StatelessWidget {
  const CardOne({
    super.key,
    required this.color,
    required this.heading,
    required this.amount,
  });

  final Color color;
  final String heading;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  heading,
                  style: TextStyle(color: color, fontSize: 14),
                ),
                FittedBox( // ✅ ensures text shrinks to fit, avoids "..."
                  fit: BoxFit.scaleDown,
                  child: Text(
                    "₹ $amount",
                    style: TextStyle(
                      color: color,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            heading == "Credit"
                ? Icons.arrow_upward_outlined
                : Icons.arrow_downward_outlined,
            color: color,
            size: 28,
          ),
        ],
      ),
    );
  }
}
