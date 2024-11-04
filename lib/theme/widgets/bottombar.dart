
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:gymjoe/diet_screen/diet_screen.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../home/home.dart';
import '../../workout/workout_screen.dart';
import '../../workout/workout_types.dart';


int selectedIndex = 0;



class Bottombar extends StatefulWidget {
  final String Token;

  Bottombar({Key? key, required this.Token}) : super(key: key);

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> with TickerProviderStateMixin {
  late TabController tabController;
  late List<Widget> myChilders;


  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    getdarkmodepreviousstate();
    myChilders = [
      Home(Token: widget.Token),
      WorkoutPlansPage(Token: widget.Token),
      DietPlanScreen(Token: widget.Token),
      Home(Token: widget.Token),
    ];
  }

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    // Handle dark mode state if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          myChilders[selectedIndex], // Display selected page
          Positioned(
            bottom: 20, // Move the bottom navigation up from the bottom
            left: 20, // To reduce the width and center it
            right: 20, // Equal padding on both sides to reduce width
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              decoration: BoxDecoration(
                color: const Color(0xFF050505),
                borderRadius: BorderRadius.circular(13),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Home Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 0;
                      });
                    },
                    child: Container(

                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 0 ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/home.svg',
                        width: 27,
                        height: 27,
                      //  color: selectedIndex == 0 ? Colors.red : Colors.white, // Highlight when selected
                      ),
                    ),
                  ),

                  // Order Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 1;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: selectedIndex == 1 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 1 ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        'assets/icons/peoplephoto.png',
                        width: 47,
                        height: 47,
                        fit: BoxFit.contain,
                       // color: selectedIndex == 1 ? Colors.red : null, // Highlight when selected
                      ),
                    ),
                  ),

                  // Cart Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedIndex == 2 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 2 ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/vector.svg',
                        width: 27,
                        height: 27,
                      //  color: selectedIndex == 2 ? Colors.red : Colors.white, // Highlight when selected
                      ),
                    ),
                  ),

                  // Profile Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = 3;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: selectedIndex == 3 ? Colors.red : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 3 ? Colors.red : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Image.asset(
                        'assets/icons/profile.png',
                        width: 47,
                        height: 47,
                        fit: BoxFit.contain,
                       // color: selectedIndex == 3 ? Colors.red : null, // Highlight when selected
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
