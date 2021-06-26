import 'package:flutter/material.dart';

class CustomColors {
  static final Color firebaseNavy = Color(0xFF2C384A);
  static final Color firebaseOrange = Color(0xFFF57C00);
  static final Color firebaseAmber = Color(0xFFFFA000);
  static final Color firebaseYellow = Color(0xFFFFCA28);
  static final Color firebaseGrey = Color(0xFFECEFF1);
  static final Color googleBackground = Color(0xFF4285F4);
}

final ThemeData kIOSTheme = ThemeData(
    primarySwatch: Colors.blue,
    primaryColor: Colors.blue[900],
    primaryColorBrightness: Brightness.light,
    backgroundColor: Colors.grey[700]);

final ThemeData kDefaultTheme = ThemeData(
    primarySwatch: Colors.grey,
    accentColor: Colors.blueAccent[400],
    primaryColorBrightness: Brightness.light,
    backgroundColor: Colors.grey[900]);
