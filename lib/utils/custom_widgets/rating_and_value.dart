import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class RatingAndValue extends StatelessWidget {
  const RatingAndValue({super.key, required this.ratingValue});

  final double ratingValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(ratingValue.toString(), style: Theme.of(context).textTheme.labelSmall),
        Icon(Icons.star_rounded, size: 18, color: primaryDullYellow),
      ],
    );
  }
}
