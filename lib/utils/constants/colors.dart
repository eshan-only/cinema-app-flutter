import 'package:flutter/material.dart';

/// This class contains all the Colors that are already specified.
class MyColors{
  MyColors._();

  //App Basic Colors
  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE248);
  static const Color accent = Color(0xFFb0c7ff);

  // Text Colors
  static const Color textprimary = Color(0xFF333333);
  static const Color textsecondary = Color(0xFF6c7570);
  static const Color textaccent = Colors.white;

  // Background Colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackgroundColor = Color(0xFFF3F5FF);

  // Background Container Colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = Colors.white.withOpacity(0.1);

  // Button Colors
  static const Color buttonPrimary = Color(0xFF4668ff);
  static const Color buttonSecondary = Color(0xFF6C7570);
  static const Color buttonDisabled = Color(0xFFC4C4C4);
  
  // Border Colors
  static const Color borderPrimary = Color(0xFF090909);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and Validation Colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF197602);
  
  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkestGrey = Color.fromARGB(255, 49, 48, 48);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
}