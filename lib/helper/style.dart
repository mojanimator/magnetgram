import 'package:flutter/material.dart';

class Styles {
  static TextStyle TEXTSTYLE = TextStyle(
    fontFamily: 'Tanha',
    fontSize: 20.0,
    color: primaryColor,
  );

  static TextStyle BUTTONSTYLE = TextStyle(
      color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold);
  static TextStyle TABSELECTEDSTYLE = TextStyle(
      fontFamily: 'Tanha',
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Colors.white);
  static TextStyle TABSTYLE =
      TextStyle(fontFamily: 'Tanha', fontSize: 20.0, color: Colors.white70);
  static Color primaryColor = Colors.blue;
  static Color secondaryColor = Colors.pinkAccent;
  static Color successColor = Colors.green;
  static Color cancelColor = Colors.red;
  static Color vipColor = Colors.yellowAccent;
}
