// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeLineMonth extends StatefulWidget {
  const TimeLineMonth({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;     // UNDERSTAND

  @override
  State<TimeLineMonth> createState() => _TimeLineMonth();
}

class _TimeLineMonth extends State<TimeLineMonth> {
  String currentMonth = "";
  List<String> months = [];
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    for (int i = -18; i <= 0; i++) {
      DateTime date = DateTime(now.year, now.month + i, 1).add(Duration(days: 0)); 
      months.add(DateFormat('MMM y').format(date));
    }
    currentMonth = DateFormat('MMM y').format(now);

    // Scroll to the current month after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelectedMonth();
    });
  }

  void scrollToSelectedMonth() {
    final selectedMonthIndex = months.indexOf(currentMonth);
    if (selectedMonthIndex != -1) {
      double screenWidth = MediaQuery.of(context).size.width; //  Dynamically get screen width
      double itemWidth = 100.0;
      double scrollOffset = (selectedMonthIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

      scrollController.animateTo(
        scrollOffset.clamp(0.0, scrollController.position.maxScrollExtent), // Ensure valid scroll range
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Increased height for better spacing
      child: ListView.builder(
        controller: scrollController,
        itemCount: months.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // smooth bouncing effect
        itemBuilder: (context, index) {
          bool isSelected = currentMonth == months[index]; // Improved readability
          return GestureDetector(
            onTap: () {
              setState(() {
                currentMonth = months[index];
                widget.onChanged( months[index]);    // UNDERSTAND
              });
              scrollToSelectedMonth();
            },
            child: AnimatedContainer( // Used AnimatedContainer for smooth UI transition
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 100,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Improved spacing
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade900 : Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.blue.shade900.withOpacity(0.5), blurRadius: 5)] //  Added glow effect for selected month
                    : [],
              ),
              child: Center(
                child: Text(
                  months[index],
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.w500, 
                    color: isSelected ? Colors.white : Colors.purple,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
