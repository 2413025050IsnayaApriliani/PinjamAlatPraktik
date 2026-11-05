import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF14213D);
  static const blue = Color(0xFF3867F4);
  static const background = Color(0xFFF4F7FC);

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue, surface: Colors.white),
    appBarTheme: const AppBarTheme(
      backgroundColor: background, foregroundColor: navy, elevation: 0,
      centerTitle: false, titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: navy),
    ),
    cardTheme: CardThemeData(
      color: Colors.white, elevation: 0, margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Color(0xFFE8EDF5))),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE1E7F0))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE1E7F0))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: blue, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
      backgroundColor: blue, foregroundColor: Colors.white, elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    )),
  );
}
