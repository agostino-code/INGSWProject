import 'package:flutter/material.dart';

final ThemeData myAppThemeData = ThemeData(
    fontFamily: 'Actor',
    colorScheme: ColorScheme(
        background: Colors.grey[200]!,
        brightness: Brightness.light,
        primary: const Color(0xFF00bb00),
        onPrimary: Colors.white,
        secondary: Colors.grey[300]!,
        onSecondary: Colors.black,
        error: Colors.redAccent,
        onError: Colors.grey,
        onBackground: Colors.black,
        surface: Colors.white,
        onSurface: Colors.black));
