import 'package:flutter/material.dart';

class TextThemes {
  static TextTheme textTheme({required Color color}) => TextTheme(
    headlineLarge: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 30,
        color: color
    ),
    headlineMedium: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 25,
        color: color
    ),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: color
    ),
    bodyLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 20,
        color: color
    ),
    bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 17,
        color: color
    ),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 17,
        color: color
    ),
    labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: color
    ),
    labelMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: color
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: color
    )
  ).apply(
    fontFamily: 'Nunito'
  );
}