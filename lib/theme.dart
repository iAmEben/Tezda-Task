import 'package:flutter/material.dart';

ThemeData buildLightTheme(BuildContext context) {
  return ThemeData(
    primarySwatch: Colors.blue,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    useMaterial3: true,
  );
}