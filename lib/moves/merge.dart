import 'package:flutter/material.dart';


class MergePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  MergePageRoute({required this.page, this.duration = const Duration(milliseconds: 1000)})
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
      return Stack(
        children: <Widget>[
          SlideTransition(
            position: Tween<Offset>(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).animate(secondaryAnimation),
            child: child,
          ),
          SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: page,
          ),
        ],
      );
    },
    transitionDuration: duration,
  );
}
