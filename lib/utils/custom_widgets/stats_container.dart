import 'package:flutter/material.dart';

import '../constants.dart';

class StatsContainer extends StatelessWidget {
  const StatsContainer({
    super.key,
    required this.statValue,
    required this.statName,
    this.imagePath,
    this.iconData,
    this.iconContainerColor,
    this.width = 200,
    this.height = 250
  }) : assert(imagePath != null || iconData != null, 'Both imagePath and iconData cannot be provided at the same time'),
        assert(imagePath == null || iconData == null, 'Both imagePath and iconData cannot be null at the same time');

  final String? imagePath;
  final IconData? iconData;
  final int statValue;
  final String statName;
  final Color? iconContainerColor;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: primaryWhite,
          border: kContainerBorderSide,
          borderRadius: kContainerBorderRadius
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconContainerColor ?? primaryBlue,
              borderRadius: kContainerBorderRadius,
            ),
            child: imagePath != null ? Image.asset(
              imagePath!,
              width: 25,
              height: 25,
            ) : Icon(
              iconData!,
              size: 25,
              color: primaryWhite,
            ),
          ),
          Text(
            statValue.toString(),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 40
            ),
          ),
          Text(
            statName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: primaryGrey
            ),
          ),
        ],
      ),
    );
  }
}