import 'package:flutter/material.dart';

class Spalsh2 extends StatefulWidget {
  const Spalsh2({Key? key}) : super(key: key);

  @override
  _Spalsh2State createState() => _Spalsh2State();
}

class _Spalsh2State extends State<Spalsh2> with SingleTickerProviderStateMixin {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();

    // Start the animation after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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

                  Image.asset(
                    'assets/logogym.png',
                    fit: BoxFit.contain,
                    width: 400,
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



/*Navigator.of(context).push(FadePageRoute(
page: HomePostsContainerScreen(ID: ID),
));*/


