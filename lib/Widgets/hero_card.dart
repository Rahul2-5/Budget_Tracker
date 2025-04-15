import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// 🔧 Rewritten to calculate values from transactions instead of user doc
class HeroCard extends StatelessWidget {
  HeroCard({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context) {
    /// 🔧 Listen to user's transactions
    final Stream<QuerySnapshot> _transactionStream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _transactionStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        /// 🔧 If no data or empty list, show 0 values
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Cards(
            totalCredit: 0,
            totalDebit: 0,
            remainingAmount: 0,
          );
        }

        final transactions = snapshot.data!.docs;

        double totalCredit = 0;
        double totalDebit = 0;

        /// 🔧 Calculate totals
        for (var doc in transactions) {
          final data = doc.data() as Map<String, dynamic>;
          final type = data['type'];
          final amount = (data['amount'] ?? 0).toDouble();

          if (type == 'credit') {
            totalCredit += amount;
          } else if (type == 'debit') {
            totalDebit += amount;
          }
        }

        final remainingAmount = totalCredit - totalDebit;

        /// 🔧 Pass live-calculated values to Cards
        return Cards(
          totalCredit: totalCredit,
          totalDebit: totalDebit,
          remainingAmount: remainingAmount,
        );
      },
    );
  }
}

class Cards extends StatelessWidget {
  const Cards({
    super.key,
    required this.totalCredit,
    required this.totalDebit,
    required this.remainingAmount,
  });

  /// 🔧 Replaced data map with individual fields
  final double totalCredit;
  final double totalDebit;
  final double remainingAmount;

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
                const Text(
                  "Total Balance",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "₹ ${remainingAmount.toStringAsFixed(2)}",
                  style: const TextStyle(
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
            padding: const EdgeInsets.only(top: 30, bottom: 10, left: 10, right: 10),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: CardOne(
                    color: Colors.green,
                    heading: 'Credit',
                    amount: totalCredit.toStringAsFixed(2),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CardOne(
                    color: Colors.red,
                    heading: 'Debit',
                    amount: totalDebit.toStringAsFixed(2),
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
                FittedBox(
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
