import 'package:flutter/material.dart';

ThemeData buildLightTheme(BuildContext context) {
  return ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,

    textTheme: const TextTheme(
      headlineLarge: TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
      bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14),
    ),
  );
}