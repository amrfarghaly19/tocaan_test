import 'package:flutter/material.dart';

import '../diet_nodel.dart';
import '../utils.dart';

class NutrientBar extends StatelessWidget {
  final NutrientInfo info;

  const NutrientBar({Key? key, required this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${info.label} - ${info.value}/${info.total}g',
          style: AppTextStyles.bodyStyle,
        ),
        const SizedBox(height: 6),
        Container(
          width: 88,
          height: 6,
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: FractionallySizedBox(
            widthFactor: info.value / info.total,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(7),
              ),
            ),
          ),
        ),
      ],
    );
  }
}