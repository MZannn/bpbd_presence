import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Themes {
  static ThemeData light = ThemeData(
    useMaterial3: true,
    textTheme: TextTheme(
      titleLarge: GoogleFonts.montserrat(
        fontSize: 32,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: GoogleFonts.montserrat(
        fontSize: 20,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      ),
      bodyLarge: GoogleFonts.montserrat(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      bodyMedium: GoogleFonts.montserrat(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      bodySmall: GoogleFonts.montserrat(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: GoogleFonts.montserrat(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}
