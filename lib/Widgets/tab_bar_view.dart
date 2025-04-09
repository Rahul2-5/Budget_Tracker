import 'package:budget_tracker/Widgets/transactionList.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TypeTabBar extends StatefulWidget {
  const TypeTabBar({
    super.key,
    required this.category,
    required this.monthYear,
  });

  final String category;
  final String monthYear;

  @override
  State<TypeTabBar> createState() => _TypeTabBarState();
}

class _TypeTabBarState extends State<TypeTabBar> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int creditCount = 0;
  int debitCount = 0;

  final String userId = FirebaseAuth.instance.currentUser!.uid; // ✅ Correct user ID

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick(); // ✅ Haptics
      }
    });

    _fetchTransactionCounts(); // ✅ Initial fetch
  }

  @override
  void didUpdateWidget(covariant TypeTabBar oldWidget) {  // to compare old widget with new widget(fetches if changes occurs)
    super.didUpdateWidget(oldWidget);
    if (oldWidget.category != widget.category || oldWidget.monthYear != widget.monthYear) {
      _fetchTransactionCounts(); // ✅ Re-fetch if filters changed
    }
  }

  Future<void> _fetchTransactionCounts() async {
    final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

    final baseQuery = userRef
        .collection("transactions")
        .where('monthyear', isEqualTo: widget.monthYear);

    // Credit
    var creditQuery = baseQuery.where('type', isEqualTo: 'credit');
    if (widget.category != "All") {
      creditQuery = creditQuery.where('category', isEqualTo: widget.category);
    }
    var creditSnapshot = await creditQuery.get();

    // Debit
    var debitQuery = baseQuery.where('type', isEqualTo: 'debit');
    if (widget.category != "All") {
      debitQuery = debitQuery.where('category', isEqualTo: widget.category);
    }
    var debitSnapshot = await debitQuery.get();

    setState(() {
      creditCount = creditSnapshot.size;
      debitCount = debitSnapshot.size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
             // color: Colors.blue.shade50,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.blue.shade900,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue.shade900,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: [
                  Tab(text: "Credit ($creditCount)"),
                  Tab(text: "Debit ($debitCount)"),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  Transactionlist(
                    category: widget.category,
                    monthYear: widget.monthYear,
                    type: 'credit',
                  ),
                  Transactionlist(
                    category: widget.category,
                    monthYear: widget.monthYear,
                    type: 'debit',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
