
import 'dart:async';
import 'package:flutter/material.dart';

class LoadingLogo extends StatefulWidget {
  const LoadingLogo({super.key});

  @override
  State<LoadingLogo> createState() => _LoadingLogoState();
}

class _LoadingLogoState extends State<LoadingLogo> {
  bool _isVisible = false;
  bool _flashingVisible = true; // To toggle the visibility for flashing
  Timer? _flashTimer;

  @override
  void initState() {
    super.initState();

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) { // Check if widget is still mounted before calling setState
        setState(() {
          _isVisible = true;
        });
      }

      // Start the flashing effect after the animations complete
      Future.delayed(const Duration(seconds: 1), () {
        startFlashing();
      });
    });
  }

  void startFlashing() {
    // Create a Timer to toggle opacity (flashing effect)
    _flashTimer = Timer.periodic(const Duration(milliseconds: 900), (timer) {
      if (timer.tick <= 50) { // Flash 3 times (tick is twice per flash)
        if (mounted) { // Check if widget is still mounted before calling setState
          setState(() {
            _flashingVisible = !_flashingVisible;
          });
        }
      } else {
        timer.cancel(); // Stop the flashing after 3 flashes
      }
    });
  }

  @override
  void dispose() {
    _flashTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.transparent,
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
                                      width: screenWidth / 3,
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
                                      width: screenWidth / 3,
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
                                      width: screenWidth / 2 - 10,
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

