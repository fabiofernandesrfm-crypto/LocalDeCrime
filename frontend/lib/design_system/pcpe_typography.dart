import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pcpe_colors.dart';

/// Sistema tipográfico da PCPE.
/// Utiliza Montserrat para headlines e Inter para corpo,
/// garantindo legibilidade e hierarquia visual clara.
class PCPETypography {
  PCPETypography._();

  // ── Font Families ───────────────────────────────────────────
  static const String displayFont = 'Montserrat';
  static const String bodyFont = 'Inter';

  // ── Headlines (Montserrat) ──────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.montserrat(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: PCPEColors.black,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.montserrat(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: PCPEColors.black,
        letterSpacing: -0.5,
      );

  static TextStyle get displaySmall => GoogleFonts.montserrat(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: PCPEColors.black,
      );

  static TextStyle get headlineLarge => GoogleFonts.montserrat(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: PCPEColors.black,
      );

  static TextStyle get headlineMedium => GoogleFonts.montserrat(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: PCPEColors.black,
      );

  static TextStyle get headlineSmall => GoogleFonts.montserrat(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: PCPEColors.black,
      );

  // ── Titles (Inter) ──────────────────────────────────────────
  static TextStyle get titleLarge => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: PCPEColors.black,
      );

  static TextStyle get titleMedium => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: PCPEColors.black,
      );

  static TextStyle get titleSmall => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: PCPEColors.black,
      );

  // ── Body (Inter) ────────────────────────────────────────────
  static TextStyle get bodyLarge => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: PCPEColors.black,
      );

  static TextStyle get bodyMedium => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: PCPEColors.black,
      );

  static TextStyle get bodySmall => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: PCPEColors.darkGray,
      );

  // ── Labels (Inter) ──────────────────────────────────────────
  static TextStyle get labelLarge => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: PCPEColors.black,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: PCPEColors.darkGray,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: PCPEColors.mediumGray,
        letterSpacing: 0.5,
      );

  // ── Special ─────────────────────────────────────────────────
  static TextStyle get badge => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: PCPEColors.pureWhite,
        letterSpacing: 0.3,
      );

  static TextStyle get overline => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: PCPEColors.mediumGray,
        letterSpacing: 1.5,
      );

  // ── TextTheme Material ──────────────────────────────────────
  static TextTheme get materialTextTheme =>
      GoogleFonts.interTextTheme().copyWith(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}