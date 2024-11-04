import 'package:flutter/material.dart';

class CubePageRoute extends PageRouteBuilder {
  final Widget enterPage;
  final Widget exitPage;
  final Duration duration;
  final bool reverse;

  CubePageRoute({
    required this.enterPage,
    required this.exitPage,
    this.duration = const Duration(milliseconds: 800),
    this.reverse = false, // Set this to true for reverse animation
  }) : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) => enterPage,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      return Stack(
        children: <Widget>[
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(reverse ? 3.1416 * animation.value / 2 : -3.1416 * animation.value / 2),
            alignment: reverse ? Alignment.centerLeft : Alignment.centerRight,
            child: exitPage,
          ),
          Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(reverse ? -3.1416 * (1 - animation.value) / 2 : 3.1416 * (1 - animation.value) / 2),
            alignment: reverse ? Alignment.centerRight : Alignment.centerLeft,
            child: enterPage,
          ),
        ],
      );
    },
    transitionDuration: duration,
  );
}
