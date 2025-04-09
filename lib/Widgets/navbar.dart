import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  const Navbar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60,
      backgroundColor: Colors.blue.withOpacity(0.1),
      selectedIndex: selectedIndex,
      onDestinationSelected: (int index) {
        onDestinationSelected(index);
      },
      indicatorColor: Colors.blue.shade900,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      animationDuration: Duration(milliseconds: 300),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home, color: Colors.black87),
          selectedIcon: Icon(Icons.home, color: Colors.white),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.explore, color: Colors.black87),
          selectedIcon: Icon(Icons.explore, color: Colors.white),
          label: 'Transactions',
        ),
      ],
    );
  }
}
