import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../constants.dart';

class RatingStars extends StatelessWidget {
  const RatingStars({
    super.key,
    this.iconSize = 20,
    this.onRatingUpdate,
    this.ignoreGestures = true,
    this.initialRating = 5.0,
    this.itemPaddingValue = 0.0,
  });

  final double iconSize;
  final bool ignoreGestures;
  final void Function(double)? onRatingUpdate;
  final double initialRating;
  final double itemPaddingValue;

  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
        minRating: 1.0,
        glow: false,
        unratedColor: primaryBlue.withValues(alpha: 0.3),
        itemCount: 5,
        itemPadding: EdgeInsets.symmetric(horizontal: itemPaddingValue),
        itemSize: iconSize,
        allowHalfRating: true,
        initialRating: initialRating,
        ignoreGestures: ignoreGestures,
        itemBuilder: (context, index) {
          return Icon(
            CupertinoIcons.star_fill,
            color: primaryBlue,
          );
        },
        onRatingUpdate: onRatingUpdate ?? (value) {}
    );
  }
}
