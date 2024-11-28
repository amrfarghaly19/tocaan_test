/*

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:gymjoe/diet_screen/diet_screen.dart';


import 'package:shared_preferences/shared_preferences.dart';

import '../../home/home.dart';
import '../../profile/profile.dart';
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
      ProfilePage(Token: widget.Token),
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

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/homenew.svg',
                          width: 27,
                          height: 27,
                        //  color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
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

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 1 ? Color(0XFFFF0336) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 1 ? Color(0XFFFF0336) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/gymnewfinal.svg',
                          width: 27,
                          height: 27,
                          //  color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
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

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/foodnewlast.svg',
                          width: 27,
                          height: 27,
                        //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
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

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 3 ? Color(0XFFFF0336) : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 3 ? Color(0XFFFF0336) : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/profileneww.svg',
                          width: 27,
                          height: 27,
                          //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
                      ),

                   */
/*   Image.asset(
                        'assets/icons/profile.png',
                        width: 47,
                        height: 47,
                        fit: BoxFit.contain,
                       // color: selectedIndex == 3 ? Color(0XFFFF0336) : null, // Highlight when selected
                      ),*/ /*

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
*/


// bottombar.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gymjoe/home/home.dart';
import 'package:provider/provider.dart';
import '../../diet_screen/diet_screen.dart';
import '../../profile/profile.dart';
import '../../workout/workout_types.dart';
import 'bottombar_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Bottombar extends StatefulWidget {
  final String Token;

  Bottombar({Key? key, required this.Token}) : super(key: key);

  @override
  _BottombarState createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> with TickerProviderStateMixin {
  late List<Widget> myChilders;

  @override
  void initState() {
    super.initState();
    _getDarkModePreviousState();
    myChilders = [
      Home(Token: widget.Token),
      WorkoutPlansPage(Token: widget.Token),
      DietPlanScreen(Token: widget.Token),
      ProfilePage(Token: widget.Token),
    ];
  }
int selectedIndex=0;

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
     selectedIndex = navigationProvider.selectedIndex;

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
                        navigationProvider.setIndex(0);
                        selectedIndex = 0;
                      });
                    },
                    child: Container(

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors
                            .transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors
                              .transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/homenew.svg',
                          width: 27,
                          height: 27,
                          //  color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
                      ),
                    ),
                  ),

                  // Order Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        navigationProvider.setIndex(1);
                        selectedIndex = 1;
                      });
                    },
                    child: Container(

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 1 ? Color(0XFFFF0336) : Colors
                            .transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 1 ? Color(0XFFFF0336) : Colors
                              .transparent,
                          width: 2,
                        ),
                      ),
                      child:
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/gymnewfinal.svg',
                          width: 27,
                          height: 27,
                          //  color: selectedIndex == 0 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
                      ),
                    ),
                  ),

                  // Cart Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        navigationProvider.setIndex(2);
                        selectedIndex = 2;
                      });
                    },
                    child: Container(

                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors
                            .transparent,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors
                              .transparent,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SvgPicture.asset(
                          'assets/icons/foodnewlast.svg',
                          width: 27,
                          height: 27,
                          //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                        ),
                      ),
                    ),
                  ),

                  // Profile Icon
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        navigationProvider.setIndex(3);
                        selectedIndex = 3;
                      });
                    },
                    child: Container(

                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selectedIndex == 3 ? Color(0XFFFF0336) : Colors
                              .transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: selectedIndex == 3
                                ? Color(0XFFFF0336)
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: SvgPicture.asset(
                            'assets/icons/profileneww.svg',
                            width: 27,
                            height: 27,
                            //  color: selectedIndex == 2 ? Color(0XFFFF0336) : Colors.white, // Highlight when selected
                          ),
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


  Future<void> _getDarkModePreviousState() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previousState = prefs.getBool("setIsDark");
    // Handle dark mode state if necessary
  }

/*
  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final selectedIndex = navigationProvider.selectedIndex;

    return Scaffold(
      body: myChilders[selectedIndex], // Display selected page
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20, right: 20),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          decoration: BoxDecoration(
            color: const Color(0xFF050505),
            borderRadius: BorderRadius.circular(13),
            */
/*boxShadow: [
              BoxShadow(
                color: Colors.white.withOpacity(0.4),
                blurRadius: 5,
              ),
            ],*/ /*

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Home Icon
              _buildNavItem(
                context,
                index: 0,
                assetPath: 'assets/icons/homenew.svg',
              ),

              // Workout Icon
              _buildNavItem(
                context,
                index: 1,
                assetPath: 'assets/icons/gymnewfinal.svg',
              ),

              // Diet Icon
              _buildNavItem(
                context,
                index: 2,
                assetPath: 'assets/icons/foodnewlast.svg',
              ),

              // Profile Icon
              _buildNavItem(
                context,
                index: 3,
                assetPath: 'assets/icons/profileneww.svg',
              ),
            ],
          ),
        ),
      ),
    );
  }
*/

  Widget _buildNavItem(BuildContext context,
      {required int index, required String assetPath}) {
    final navigationProvider = Provider.of<NavigationProvider>(context);
    final isSelected = navigationProvider.selectedIndex == index;

    return GestureDetector(
      onTap: () {
        navigationProvider.setIndex(index);
      },
      child: Container(
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isSelected ? Color(0XFFFF0336) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0XFFFF0336) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SvgPicture.asset(
            assetPath,
            width: 27,
            height: 27,
            // Optionally, change the color based on selection
            // color: isSelected ? Color(0XFFFF0336) : Colors.white,
          ),
        ),
      ),
    );
  }
}


//   int currentIndex = Provider.of<NavigationProvider>(context).selectedIndex;
//   int currentIndex = Provider.of<NavigationProvider>(context, listen: false).selectedIndex;
//  Provider.of<NavigationProvider>(context, listen: false).setIndex(2); // For example, to navigate to the third tab