import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pcpe_colors.dart';
import 'pcpe_typography.dart';
import 'pcpe_spacing.dart';
import 'pcpe_border_radius.dart';

/// Tema central da aplicação PCPE, construído sobre o Design System.
///
/// Centraliza todos os tokens de design em um único [ThemeData]
/// usado pelo MaterialApp.router.
///
/// Identidade visual: preto grafite (#1B1B1B) e dourado institucional.
class PCPETheme {
  PCPETheme._();

  // ── Theme Builders ──────────────────────────────────────────

  static ThemeData get light => _buildTheme();
  static ThemeData get dark => _buildDarkTheme();

  static ThemeData _buildTheme() {
    final colorScheme = ColorScheme.light(
      primary: PCPEColors.primary,
      onPrimary: PCPEColors.pureWhite,
      secondary: PCPEColors.primaryLight,
      onSecondary: PCPEColors.black,
      surface: PCPEColors.pureWhite,
      onSurface: PCPEColors.black,
      error: PCPEColors.error,
      onError: PCPEColors.pureWhite,
      brightness: Brightness.light,
    );

    return _buildCommonTheme(colorScheme);
  }

  static ThemeData _buildDarkTheme() {
    final colorScheme = ColorScheme.dark(
      primary: const Color(0xFFD8B75C),
      onPrimary: const Color(0xFF1B1B1B),
      secondary: const Color(0xFFC8A74E),
      onSecondary: const Color(0xFF1B1B1B),
      surface: const Color(0xFF1E1E2E),
      onSurface: const Color(0xFFE0E0E0),
      error: const Color(0xFFEF9A9A),
      onError: const Color(0xFF3E1111),
      brightness: Brightness.dark,
    );

    return _buildCommonTheme(colorScheme).copyWith(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF121220),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1E2E),
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: PCPEBorderRadius.card,
          side: BorderSide(
            color: Colors.white.withValues(alpha: 0.06),
            width: 0.5,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: const Color(0xFF1E1E2E),
        foregroundColor: const Color(0xFFE0E0E0),
        elevation: 0,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE0E0E0),
        ),
        iconTheme: const IconThemeData(color: Color(0xFFD8B75C)),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: const Color(0xFF1E1E2E),
        elevation: 8,
        scrimColor: Colors.black54,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A3E),
        border: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: const BorderSide(color: Color(0xFFD8B75C), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: const BorderSide(color: Color(0xFFEF9A9A), width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: PCPESpacing.screenHorizontal,
          vertical: PCPESpacing.lg - 10,
        ),
        labelStyle: GoogleFonts.inter(color: const Color(0xFFB0B0B0)),
        hintStyle: GoogleFonts.inter(color: const Color(0xFF808080)),
        prefixIconColor: const Color(0xFFD8B75C),
        suffixIconColor: const Color(0xFF808080),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF2A2A3E),
        selectedColor: const Color(0xFFD8B75C).withValues(alpha: 0.15),
        labelStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFE0E0E0)),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 12, color: const Color(0xFFB0B0B0)),
        shape: RoundedRectangleBorder(borderRadius: PCPEBorderRadius.chip),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
    );
  }

  static ThemeData _buildCommonTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: PCPETypography.materialTextTheme,
      scaffoldBackgroundColor: PCPEColors.background,

      // ── AppBar ──────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: PCPEColors.pureWhite,
        foregroundColor: PCPEColors.black,
        elevation: 0,
        shadowColor: Colors.black12,
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PCPEColors.black,
        ),
        iconTheme: const IconThemeData(color: PCPEColors.primary),
      ),

      // ── Drawer ──────────────────────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: PCPEColors.pureWhite,
        elevation: 8,
        scrimColor: Colors.black38,
      ),

      // ── Card ────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: PCPEColors.pureWhite,
        elevation: 1,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(
          borderRadius: PCPEBorderRadius.card,
          side: BorderSide(
            color: PCPEColors.lightGray.withValues(alpha: 0.3),
            width: 0.5,
          ),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: PCPESpacing.screenHorizontal,
          vertical: PCPESpacing.xs + 2, // 6
        ),
      ),

      // ── Elevated Button ─────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PCPEColors.primary,
          foregroundColor: PCPEColors.pureWhite,
          disabledBackgroundColor: PCPEColors.lightGray,
          disabledForegroundColor: PCPEColors.mediumGray,
          padding: const EdgeInsets.symmetric(
            horizontal: PCPESpacing.xl,
            vertical: PCPESpacing.lg - 10, // 14
          ),
          shape: RoundedRectangleBorder(
            borderRadius: PCPEBorderRadius.button,
          ),
          elevation: 1,
          shadowColor: PCPEColors.primary.withValues(alpha: 0.2),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),

      // ── Outlined Button ─────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: PCPEColors.primary,
          side: BorderSide(
            color: PCPEColors.primary.withValues(alpha: 0.5),
            width: 1.5,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: PCPESpacing.xl,
            vertical: PCPESpacing.lg - 10, // 14
          ),
          shape: RoundedRectangleBorder(
            borderRadius: PCPEBorderRadius.button,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Input Decoration ────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: PCPEColors.cardGray,
        border: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: BorderSide(
            color: PCPEColors.lightGray.withValues(alpha: 0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: BorderSide(
            color: PCPEColors.lightGray.withValues(alpha: 0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: const BorderSide(
            color: PCPEColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: PCPEBorderRadius.input,
          borderSide: const BorderSide(
            color: PCPEColors.error,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: PCPESpacing.screenHorizontal,
          vertical: PCPESpacing.lg - 10, // 14
        ),
        labelStyle: GoogleFonts.inter(color: PCPEColors.darkGray),
        hintStyle: GoogleFonts.inter(color: PCPEColors.mediumGray),
        prefixIconColor: PCPEColors.primary,
        suffixIconColor: PCPEColors.mediumGray,
      ),

      // ── Bottom Navigation Bar ───────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: PCPEColors.pureWhite,
        selectedItemColor: PCPEColors.primary,
        unselectedItemColor: PCPEColors.mediumGray,
        type: BottomNavigationBarType.fixed,
        elevation: 4,
        selectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontWeight: FontWeight.normal,
          fontSize: 11,
        ),
      ),

      // ── Navigation Rail ─────────────────────────────────────
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: PCPEColors.pureWhite,
        selectedIconTheme: const IconThemeData(
          color: PCPEColors.primary,
        ),
        unselectedIconTheme: const IconThemeData(
          color: PCPEColors.mediumGray,
        ),
        selectedLabelTextStyle: GoogleFonts.inter(
          color: PCPEColors.primary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: GoogleFonts.inter(
          color: PCPEColors.mediumGray,
          fontSize: 11,
        ),
      ),

      // ── Divider ─────────────────────────────────────────────
      dividerColor: PCPEColors.lightGray,
      dividerTheme: DividerThemeData(
        color: PCPEColors.lightGray.withValues(alpha: 0.4),
        thickness: 1,
      ),

      // ── Icon ────────────────────────────────────────────────
      iconTheme: const IconThemeData(color: PCPEColors.primary),

      // ── SnackBar ────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: PCPEColors.darkGray,
        contentTextStyle: GoogleFonts.inter(
          color: PCPEColors.pureWhite,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: PCPEBorderRadius.button,
        ),
      ),

      // ── Dialog ──────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: PCPEColors.pureWhite,
        shape: RoundedRectangleBorder(
          borderRadius: PCPEBorderRadius.dialog,
        ),
        titleTextStyle: GoogleFonts.montserrat(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: PCPEColors.black,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: PCPEColors.darkGray,
        ),
      ),

      // ── Chip ────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: PCPEColors.cardGray,
        selectedColor: PCPEColors.primary.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: PCPEColors.black,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          color: PCPEColors.darkGray,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: PCPEBorderRadius.chip,
        ),
        side: BorderSide(
          color: PCPEColors.lightGray.withValues(alpha: 0.5),
        ),
      ),

      // ── FAB ─────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: PCPEColors.primary,
        foregroundColor: PCPEColors.pureWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: PCPEBorderRadius.fab,
        ),
      ),
    );
  }
}