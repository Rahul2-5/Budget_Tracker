// ignore_for_file: deprecated_member_use

import 'package:budget_tracker/utils/icons_list.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class CategoryList extends StatefulWidget {
  const CategoryList({super.key, required this.onChanged});
  final ValueChanged<String?> onChanged;     // UNDERSTAND

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String currentCategory = "";
  List<Map<String, dynamic>> categorylist =[];
 
  final ScrollController scrollController = ScrollController();
    var appIcons = AppIcons();
    var addCat = {
      "name": "All",
      "icon": FontAwesomeIcons.cartPlus,
    };

  @override
  void initState() {
    super.initState();
    setState(() {
        categorylist =  appIcons.HomeExpensesCategory;
     categorylist.insert(0, addCat);
    });
  
   
  }

  

  @override
  Widget build(BuildContext context) {
   
    return Container(
      height: 45, // Increased height for better spacing
      child: ListView.builder(
        controller: scrollController,
        itemCount: categorylist.length,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // smooth bouncing effect
        itemBuilder: (context, index) {
          var data = categorylist[index];
          bool isSelected = currentCategory == data['name']; // Improved readability
          return GestureDetector(
            onTap: () {
              setState(() {
                currentCategory = data['name'];
                widget.onChanged( data['name']);    // UNDERSTAND
              });
             
            },
            child: AnimatedContainer( // Used AnimatedContainer for smooth UI transition
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Improved spacing
              padding: EdgeInsets.only(left: 12 , right : 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade900 : Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected
                    ? [BoxShadow(color: Colors.blue.shade900.withOpacity(0.5), blurRadius: 5)] //  Added glow effect for selected month
                    : [],
              ),
              child: Center(
                child: Row(
                  children: [
                    Icon(data['icon'], size:15, color: isSelected ? Colors.white : Colors.blue.shade900,),
                    SizedBox(width: 10,),
                    Text(
                      data['name'],
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.w500, 
                        color: isSelected ? Colors.white : Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
