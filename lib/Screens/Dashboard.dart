import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_tracker/Screens/home_screen.dart';
import 'package:budget_tracker/Screens/transaction_screen.dart';
import 'package:budget_tracker/Widgets/navbar.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late final PageController _pageController;
  int currentIndex = 0;

  final List<Widget> pages = [
    const HomeScreen(),
    TransactionScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
  }

  void _onTabChanged(int index) {
    if (index == currentIndex) return;

    HapticFeedback.lightImpact();

    setState(() => currentIndex = index);

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: pages.length,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe
        itemBuilder: (_, index) => pages[index],
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: currentIndex,
        onDestinationSelected: _onTabChanged,
      ),
    );
  }
}
