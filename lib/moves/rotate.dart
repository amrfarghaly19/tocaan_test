import 'package:flutter/material.dart';

class RotatePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  RotatePageRoute({required this.page, this.duration = const Duration(milliseconds: 300)})
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
      return RotationTransition(
        turns: animation,
        child: child,
      );
    },
    transitionDuration: duration,
  );
}
