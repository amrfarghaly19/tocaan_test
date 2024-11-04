import 'package:flutter/material.dart';

class MealImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const MealImage({
    Key? key,
    required this.imageUrl,
    this.width = 79,
    this.height = 61,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}