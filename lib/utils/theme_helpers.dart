import 'package:flutter/material.dart';
import 'package:service_app_admin_panel/utils/constants.dart';
import 'package:service_app_admin_panel/utils/text_themes.dart';

class ThemeHelpers {

  static ThemeData themeData = ThemeData(
    useMaterial3: true
  ).copyWith(
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
    ),
    textTheme: TextThemes.textTheme(color: primaryBlack),
    appBarTheme: AppBarTheme(
      backgroundColor: primaryWhite,
      scrolledUnderElevation: 0,
      surfaceTintColor: primaryWhite,
      elevation: 0,
      shadowColor: Colors.black12
    ),
    scaffoldBackgroundColor: panelBackground,
    inputDecorationTheme: InputDecorationTheme(
      enabledBorder: kEnabledBorder,
      focusedBorder: kFocusedBorder,
      errorBorder: kErrorBorder,
      focusedErrorBorder: kFocusedErrorBorder,
      filled: true,
      fillColor: primaryGrey20
    )
  );

}