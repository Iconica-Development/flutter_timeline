import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF71C6D1);

ThemeData theme = ThemeData(
  actionIconTheme: ActionIconThemeData(
    backButtonIconBuilder: (context) {
      return const Icon(Icons.arrow_back_ios_new_rounded);
    },
  ),
  scaffoldBackgroundColor: const Color(0xFFFAF9F6),
  primaryColor: primaryColor,
  checkboxTheme: CheckboxThemeData(
    side: const BorderSide(
      color: Color(0xFF8D8D8D),
      width: 1,
    ),
    fillColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return const Color(0xFFEEEEEE);
      },
    ),
  ),
  switchTheme: SwitchThemeData(
    trackColor:
        WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (!states.contains(WidgetState.selected)) {
        return const Color(0xFF8D8D8D);
      }
      return primaryColor;
    }),
    thumbColor: const WidgetStatePropertyAll(
      Colors.white,
    ),
  ),
  appBarTheme: const AppBarTheme(
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 16,
      ),
      elevation: 0,
      backgroundColor: Color(0xFF212121),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 24,
        color: Color(0xFF71C6D1),
        fontFamily: "Merriweather",
      ),
      actionsIconTheme: IconThemeData()),
  fontFamily: "Merriweather",
  useMaterial3: false,
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24,
      color: Color(0xFF71C6D1),
    ),

    displayLarge: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w800,
      fontSize: 20,
      color: Colors.white,
    ),
    displayMedium: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w800,
      fontSize: 18,
      color: Color(0xFF71C6D1),
    ),
    displaySmall: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w800,
      fontSize: 14,
      color: Colors.black,
    ),

    // TITLE
    titleSmall: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w800,
      fontSize: 14,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w800,
      fontSize: 16,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w800,
      fontSize: 20,
      color: Colors.black,
    ),

    // LABEL
    labelSmall: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: Color(0xFF8D8D8D),
    ),

    // BODY
    bodySmall: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontFamily: "Avenir",
      fontWeight: FontWeight.w400,
      fontSize: 16,
      color: Colors.black,
    ),
  ),
  radioTheme: RadioThemeData(
    visualDensity: const VisualDensity(
      horizontal: 0,
      vertical: -2,
    ),
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    fillColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.black;
      },
    ),
  ),
  colorScheme: const ColorScheme.light(
    primary: primaryColor,
  ),
);
