import 'package:flutter/material.dart';

/// Colors

const primaryWhite = Colors.white;
const primaryBlack = Colors.black;
const primaryBlue = Color(0xff0059B3);
const panelBackground = Color(0xfff6f6f6);
const primaryDullYellow = Color(0xffe4b61a);
Color primaryGrey = Colors.grey.shade400;
Color primaryGrey20 = primaryGrey.withValues(alpha: 0.2);

/// Container Decorations
  /// Border Radius
  BorderRadius kContainerBorderRadius = BorderRadius.circular(12);

  /// Border
  Border kContainerBorderSide = Border.all(
    color: primaryGrey.withValues(alpha: 0.5),
    width: 0.6
  );

/// Months list
const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December'
];