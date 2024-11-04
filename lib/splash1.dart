
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gymjoe/Auth/login.dart';
import 'package:gymjoe/splash2.dart';
import 'moves/fade.dart';

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  _Splash1State createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> with SingleTickerProviderStateMixin {
  bool _isVisible = false;
  bool _flashingVisible = true; // To toggle the visibility for flashing

  @override
  void initState() {
    super.initState();

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        _isVisible = true;
      });

      // Start the flashing effect after the animations complete
      Future.delayed(const Duration(seconds: 2), () {
        startFlashing();
      });

    });
    Future.delayed(const Duration(seconds: 6), () {
      print("Navigated");
      Navigator.of(context).push(FadePageRoute(
        page: LoginPage(),
      ));

    });
  }

  void startFlashing() {
    // Create a Timer to toggle opacity (flashing effect)
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      if (timer.tick <= 6) { // Flash 3 times (tick is twice per flash)
        setState(() {
          _flashingVisible = !_flashingVisible;
        });
      } else {
        timer.cancel(); // Stop the flashing after 3 flashes
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    print(screenWidth);
    return Container(
      color: const Color(0xFF252525),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Left image animation
                          Flexible(
                            flex: 1,
                            child: TweenAnimationBuilder<Offset>(
                              tween: Tween<Offset>(
                                begin: const Offset(-1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              ),
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: Offset(offset.dx * MediaQuery.of(context).size.width, 0.0),
                                  child: Hero(
                                    tag: 'logo',
                                    child: Image.asset(
                                      'assets/2left.png',
                                      fit: BoxFit.contain,
                                      width: screenWidth/3,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Right image animation
                          Flexible(
                            flex: 1,
                            child: TweenAnimationBuilder<Offset>(
                              tween: Tween<Offset>(
                                begin: const Offset(1.0, 0.0),
                                end: const Offset(0.0, 0.0),
                              ),
                              duration: const Duration(seconds: 2),
                              curve: Curves.easeInOut,
                              builder: (context, offset, child) {
                                return Transform.translate(
                                  offset: Offset(offset.dx * MediaQuery.of(context).size.width, 0.0),
                                  child: Hero(
                                  tag: 'logo',
                                    child: Image.asset(
                                      'assets/1right.png',
                                      fit: BoxFit.contain,
                                      width: screenWidth/3,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Transform.translate(
                          offset: const Offset(0.0, 55.0),
                          child: TweenAnimationBuilder<Offset>(
                            tween: Tween<Offset>(
                              begin: const Offset(0.0, 1.0),
                              end: const Offset(0.0, 0.0),
                            ),
                            duration: const Duration(seconds: 2),
                            curve: Curves.easeInOut,
                            builder: (context, offset, child) {
                              return Transform.translate(
                                offset: Offset(0.0, offset.dy * MediaQuery.of(context).size.height),
                                child: AnimatedOpacity(
                                  opacity: _flashingVisible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 500),
                                  child: Hero(
                                    tag: 'logo',
                                    child: Image.asset(
                                      'assets/midlogo.png',
                                      fit: BoxFit.contain,
                                      width: screenWidth/2 -10,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
