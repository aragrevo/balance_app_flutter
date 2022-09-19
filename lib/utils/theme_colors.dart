import 'package:flutter/material.dart';

class ThemeColors {
  static final ThemeColors _instance = ThemeColors._();
  factory ThemeColors() => _instance;
  ThemeColors._();
  static ThemeColors get to => _instance;

  Color darkblue = const Color(0xff2c4260);
  Color darkgray = const Color(0xff77839a);
  Color black = const Color(0xff2B322F);
  Color backgroundCard = const Color.fromRGBO(249, 249, 249, 1);
}
