import 'package:flutter/material.dart';

class TextThemes {
  static TextTheme textTheme({required Color color}) => TextTheme(
    headlineLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 30,
        color: color
    ),
    headlineMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: color
    ),
    headlineSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 25,
        color: color
    ),
    bodyLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 20,
        color: color
    ),
    bodyMedium: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 17,
        color: color
    ),
    bodySmall: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 14,
        color: color
    ),
    labelLarge: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: color
    ),
  );
}