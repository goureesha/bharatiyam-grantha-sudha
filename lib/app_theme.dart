import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// ── Design System for Bharatiyam Grantha Sudha ──
/// Rich, warm Vedic aesthetic: deep browns, saffron gold, cream parchment.

class AppTheme {
  AppTheme._();

  // ── Primary Palette ──
  static const Color kSaffron      = Color(0xFFE8A317);
  static const Color kDeepSaffron  = Color(0xFFC8820E);
  static const Color kGold         = Color(0xFFD4A843);
  static const Color kCream        = Color(0xFFFFF8EE);
  static const Color kParchment    = Color(0xFFF5ECD7);
  static const Color kBrown        = Color(0xFF5C3D2E);
  static const Color kDeepBrown    = Color(0xFF3E2723);
  static const Color kMaroon       = Color(0xFF6D1B1B);

  // ── Dark mode palette ──
  static const Color kDarkBg       = Color(0xFF1A1410);
  static const Color kDarkCard     = Color(0xFF2A2018);
  static const Color kDarkSurface  = Color(0xFF332A20);
  static const Color kDarkText     = Color(0xFFF0E6D6);
  static const Color kDarkMuted    = Color(0xFFA89880);
  static const Color kDarkBorder   = Color(0xFF4A3E30);

  // ── Light mode palette ──
  static const Color kLightBg      = Color(0xFFFFF8EE);
  static const Color kLightCard    = Color(0xFFFFFFFF);
  static const Color kLightSurface = Color(0xFFF5ECD7);
  static const Color kLightText    = Color(0xFF3E2723);
  static const Color kLightMuted   = Color(0xFF8D7B6A);
  static const Color kLightBorder  = Color(0xFFE0D5C5);

  // ── Accent ──
  static const Color kAccentGreen  = Color(0xFF2E7D32);
  static const Color kAccentRed    = Color(0xFFB71C1C);

  /// Dark Theme
  static ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: kDarkBg,
      primaryColor: kSaffron,
      colorScheme: const ColorScheme.dark(
        primary: kSaffron,
        secondary: kGold,
        surface: kDarkCard,
        error: kAccentRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kDarkCard,
        foregroundColor: kDarkText,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: kSaffron,
        ),
      ),
      cardTheme: CardThemeData(
        color: kDarkCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: kDarkBorder.withOpacity(0.5)),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.notoSansKannada(
          fontSize: 24, fontWeight: FontWeight.w800, color: kSaffron,
        ),
        headlineMedium: GoogleFonts.notoSansKannada(
          fontSize: 20, fontWeight: FontWeight.w700, color: kDarkText,
        ),
        titleLarge: GoogleFonts.notoSansKannada(
          fontSize: 16, fontWeight: FontWeight.w700, color: kDarkText,
        ),
        titleMedium: GoogleFonts.notoSansKannada(
          fontSize: 14, fontWeight: FontWeight.w600, color: kDarkText,
        ),
        bodyLarge: GoogleFonts.notoSansKannada(
          fontSize: 16, fontWeight: FontWeight.w400, color: kDarkText, height: 1.8,
        ),
        bodyMedium: GoogleFonts.notoSansKannada(
          fontSize: 14, fontWeight: FontWeight.w400, color: kDarkMuted,
        ),
        labelLarge: GoogleFonts.notoSansDevanagari(
          fontSize: 16, fontWeight: FontWeight.w400, color: kDarkText, height: 1.8,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kSaffron,
          foregroundColor: kDeepBrown,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kDarkCard,
        selectedItemColor: kSaffron,
        unselectedItemColor: kDarkMuted,
      ),
      dividerColor: kDarkBorder,
      useMaterial3: true,
    );
  }

  /// Light Theme
  static ThemeData lightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: kLightBg,
      primaryColor: kSaffron,
      colorScheme: const ColorScheme.light(
        primary: kSaffron,
        secondary: kBrown,
        surface: kLightCard,
        error: kAccentRed,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: kLightCard,
        foregroundColor: kLightText,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: kBrown,
        ),
      ),
      cardTheme: CardThemeData(
        color: kLightCard,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: kLightBorder),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.notoSansKannada(
          fontSize: 24, fontWeight: FontWeight.w800, color: kBrown,
        ),
        headlineMedium: GoogleFonts.notoSansKannada(
          fontSize: 20, fontWeight: FontWeight.w700, color: kLightText,
        ),
        titleLarge: GoogleFonts.notoSansKannada(
          fontSize: 16, fontWeight: FontWeight.w700, color: kLightText,
        ),
        titleMedium: GoogleFonts.notoSansKannada(
          fontSize: 14, fontWeight: FontWeight.w600, color: kLightText,
        ),
        bodyLarge: GoogleFonts.notoSansKannada(
          fontSize: 16, fontWeight: FontWeight.w400, color: kLightText, height: 1.8,
        ),
        bodyMedium: GoogleFonts.notoSansKannada(
          fontSize: 14, fontWeight: FontWeight.w400, color: kLightMuted,
        ),
        labelLarge: GoogleFonts.notoSansDevanagari(
          fontSize: 16, fontWeight: FontWeight.w400, color: kLightText, height: 1.8,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: kSaffron,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.notoSansKannada(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: kLightCard,
        selectedItemColor: kBrown,
        unselectedItemColor: kLightMuted,
      ),
      dividerColor: kLightBorder,
      useMaterial3: true,
    );
  }
}
