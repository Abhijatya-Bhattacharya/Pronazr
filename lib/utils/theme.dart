import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final neobrutalistTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.black,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    shadowColor: Colors.transparent,
    titleTextStyle: GoogleFonts.inter(
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w900,
      letterSpacing: 0,
    ),
    iconTheme: const IconThemeData(color: Colors.black),
    toolbarHeight: 80,
    surfaceTintColor: Colors.transparent,
  ),
  cardColor: Colors.white,
  textTheme: TextTheme(
    bodyLarge: GoogleFonts.inter(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: GoogleFonts.inter(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodySmall: GoogleFonts.inter(
      color: Colors.black87,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: GoogleFonts.inter(
      color: Colors.black54,
      fontSize: 15,
      fontWeight: FontWeight.w500,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0), // Sharp corners
      borderSide: const BorderSide(color: Colors.black, width: 3),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0), // Sharp corners
      borderSide: const BorderSide(color: Colors.black, width: 3),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(0), // Sharp corners
      borderSide: const BorderSide(color: Colors.black, width: 4),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero, // Sharp corners
        side: BorderSide(color: Colors.black, width: 3),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
    ),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.black;
      }
      return Colors.white;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.black;
      }
      return Colors.black;
    }),
    trackOutlineColor: WidgetStateProperty.all(Colors.black),
    trackOutlineWidth: WidgetStateProperty.all(3),
  ),
);
