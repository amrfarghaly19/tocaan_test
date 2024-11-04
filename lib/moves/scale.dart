
import 'package:flutter/material.dart';

class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  ScalePageRoute({required this.page, this.duration = const Duration(milliseconds: 300)})
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
      return ScaleTransition(
        scale: animation,
        child: child,
      );
    },
    transitionDuration: duration,
  );
}



/*Navigator.of(context).push(MergePageRoute(page: NewPage()));
Navigator.of(context).push(ScalePageRoute(page: NewPage()));
Navigator.of(context).push(RotatePageRoute(page: NewPage()));*/
