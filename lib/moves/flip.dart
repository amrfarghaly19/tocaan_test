import 'package:flutter/material.dart';

class FlipPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  FlipPageRoute({required this.page, this.duration = const Duration(milliseconds: 600)})
      : super(
    pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        ) => page,
    transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
        ) {
      return AnimatedBuilder(
        animation: animation,
        child: child,
        builder: (context, child) {
          final flipAnim = Tween<double>(begin: -1.0, end: 0.0)
              .animate(animation);
          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateY(flipAnim.value * 3.1416),
            alignment: Alignment.center,
            child: child,
          );
        },
      );
    },
    transitionDuration: duration,
  );
}
