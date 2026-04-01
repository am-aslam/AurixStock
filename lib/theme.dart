import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ═══════════════════════════════════════════════════════════════
//  AURIXSTOCK COLOR SYSTEM — Liquid Gold + Midnight Blue + Glass
// ═══════════════════════════════════════════════════════════════

class AurixColors {
  // ── Gold Palette ──────────────────────────────────────────
  static const Color goldPrimary = Color(0xFFE6C068);
  static const Color goldSoft = Color(0xFFF4D58D);
  static const Color goldDark = Color(0xFFB8963A);
  static const Color goldGlow = Color(0xFFFFD700);

  // ── Background & Surface ──────────────────────────────────
  static const Color bgPrimary = Color(0xFF0A0B10);
  static const Color bgSecondary = Color(0xFF12141C);
  static const Color bgElevated = Color(0xFF181A24);
  static const Color bgCard = Color(0xFF1C1F2E);
  static const Color bgGlass = Color(0x1AFFFFFF);
  static const Color bgGlassHover = Color(0x26FFFFFF);

  // ── Text ──────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B3C0);
  static const Color textMuted = Color(0xFF6C7080);
  static const Color textOnGold = Color(0xFF1A1000);

  // ── Borders & Dividers ────────────────────────────────────
  static const Color borderGlass = Color(0x33E6C068);
  static const Color borderSubtle = Color(0x1AFFFFFF);
  static const Color borderDivider = Color(0xFF1E2130);

  // ── Semantic ──────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color successBg = Color(0x1A22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0x1AEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0x1AF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0x1A3B82F6);

  // ── Credit / Debit ────────────────────────────────────────
  static const Color credit = Color(0xFF10B981);
  static const Color creditBg = Color(0x1A10B981);
  static const Color debit = Color(0xFFEF4444);
  static const Color debitBg = Color(0x1AEF4444);

  // ── Gradients ─────────────────────────────────────────────
  static const LinearGradient goldGradient = LinearGradient(
    colors: [goldPrimary, goldDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldShimmer = LinearGradient(
    colors: [goldDark, goldSoft, goldPrimary, goldSoft, goldDark],
    stops: [0.0, 0.25, 0.5, 0.75, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF1A1400), Color(0xFF0A0B10)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [bgPrimary, bgSecondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [bgCard, bgElevated],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient creditGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF059669)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient debitGradient = LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Glassmorphism helper
  static BoxDecoration glassCard({
    double borderRadius = 20,
    Color? borderColor,
    List<BoxShadow>? shadows,
  }) =>
      BoxDecoration(
        color: bgGlass,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: borderColor ?? borderGlass,
          width: 1.0,
        ),
        boxShadow: shadows ??
            [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: goldPrimary.withOpacity(0.05),
                blurRadius: 40,
                offset: const Offset(0, 0),
              ),
            ],
      );

  static BoxDecoration goldCard({double borderRadius = 20}) => BoxDecoration(
        gradient: goldGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: goldPrimary.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      );
}

// ═══════════════════════════════════════════════════════════════
//  TYPOGRAPHY
// ═══════════════════════════════════════════════════════════════

class AurixTypography {
  static TextStyle display1(Color? color) => GoogleFonts.poppins(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: color ?? AurixColors.textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle display2(Color? color) => GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: color ?? AurixColors.textPrimary,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle headline1(Color? color) => GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color ?? AurixColors.textPrimary,
        height: 1.3,
      );

  static TextStyle headline2(Color? color) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AurixColors.textPrimary,
        height: 1.35,
      );

  static TextStyle headline3(Color? color) => GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? AurixColors.textPrimary,
        height: 1.4,
      );

  static TextStyle body1(Color? color) => GoogleFonts.poppins(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: color ?? AurixColors.textSecondary,
        height: 1.5,
      );

  static TextStyle body2(Color? color) => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color ?? AurixColors.textSecondary,
        height: 1.5,
      );

  static TextStyle caption(Color? color) => GoogleFonts.poppins(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: color ?? AurixColors.textMuted,
        letterSpacing: 0.3,
        height: 1.4,
      );

  static TextStyle label(Color? color) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color ?? AurixColors.textSecondary,
        letterSpacing: 0.5,
      );

  static TextStyle button(Color? color) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: color ?? AurixColors.textOnGold,
        letterSpacing: 0.3,
      );

  static TextStyle amount(Color? color) => GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: color ?? AurixColors.goldPrimary,
        letterSpacing: -0.5,
        height: 1.1,
      );

  static TextStyle amountSmall(Color? color) => GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color ?? AurixColors.goldPrimary,
        letterSpacing: -0.3,
        height: 1.1,
      );
}

// ═══════════════════════════════════════════════════════════════
//  THEME DATA
// ═══════════════════════════════════════════════════════════════

class AurixTheme {
  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AurixColors.bgPrimary,
      colorScheme: const ColorScheme.dark(
        primary: AurixColors.goldPrimary,
        onPrimary: AurixColors.textOnGold,
        primaryContainer: Color(0xFF2A2000),
        onPrimaryContainer: AurixColors.goldSoft,
        secondary: Color(0xFF4E9AF1),
        onSecondary: Colors.white,
        surface: AurixColors.bgSecondary,
        onSurface: AurixColors.textPrimary,
        surfaceContainerHighest: AurixColors.bgElevated,
        onSurfaceVariant: AurixColors.textSecondary,
        outline: AurixColors.borderDivider,
        error: AurixColors.error,
        onError: Colors.white,
        shadow: Colors.black,
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AurixColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AurixColors.textPrimary),
        actionsIconTheme: const IconThemeData(color: AurixColors.textSecondary),
        centerTitle: false,
      ),

      // Navigation Bar
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AurixColors.bgSecondary,
        indicatorColor: AurixColors.goldPrimary.withOpacity(0.18),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        height: 72,
        iconTheme: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return const IconThemeData(
                color: AurixColors.goldPrimary, size: 22);
          }
          return const IconThemeData(color: AurixColors.textMuted, size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AurixColors.goldPrimary,
            );
          }
          return GoogleFonts.poppins(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AurixColors.textMuted,
          );
        }),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: AurixColors.bgCard,
        elevation: 0,
        shadowColor: Colors.black.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AurixColors.borderDivider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AurixColors.goldPrimary,
          foregroundColor: AurixColors.textOnGold,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AurixColors.goldPrimary,
          side: const BorderSide(color: AurixColors.goldPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle:
              GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AurixColors.goldPrimary,
          textStyle:
              GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),

      // FAB
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AurixColors.goldPrimary,
        foregroundColor: AurixColors.textOnGold,
        elevation: 12,
        shape: CircleBorder(),
      ),

      // Input
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AurixColors.bgElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AurixColors.borderDivider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AurixColors.borderDivider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: AurixColors.goldPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AurixColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AurixColors.error, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        labelStyle:
            GoogleFonts.poppins(color: AurixColors.textMuted, fontSize: 14),
        hintStyle:
            GoogleFonts.poppins(color: AurixColors.textMuted, fontSize: 14),
        prefixIconColor: AurixColors.textMuted,
        suffixIconColor: AurixColors.textMuted,
        errorStyle: GoogleFonts.poppins(color: AurixColors.error, fontSize: 12),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AurixColors.borderDivider,
        thickness: 1,
        space: 1,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AurixColors.bgElevated,
        elevation: 24,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AurixColors.bgSecondary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),

      // SnackBar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AurixColors.bgElevated,
        contentTextStyle:
            GoogleFonts.poppins(fontSize: 13, color: AurixColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AurixColors.bgElevated,
        selectedColor: AurixColors.goldPrimary.withOpacity(0.2),
        side: const BorderSide(color: AurixColors.borderDivider),
        labelStyle:
            GoogleFonts.poppins(fontSize: 12, color: AurixColors.textSecondary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) return AurixColors.goldPrimary;
          return AurixColors.textMuted;
        }),
        trackColor: WidgetStateProperty.resolveWith((s) {
          if (s.contains(WidgetState.selected)) {
            return AurixColors.goldPrimary.withOpacity(0.3);
          }
          return AurixColors.bgElevated;
        }),
      ),

      // ListTile
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        iconColor: AurixColors.textMuted,
        textColor: AurixColors.textPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: AurixColors.textSecondary,
        size: 22,
      ),

      // Text
      textTheme: _buildTextTheme(),

      // Tab
      tabBarTheme: TabBarThemeData(
        indicatorColor: AurixColors.goldPrimary,
        labelColor: AurixColors.goldPrimary,
        unselectedLabelColor: AurixColors.textMuted,
        labelStyle:
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle:
            GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(color: AurixColors.goldPrimary, width: 2.5),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme() {
    return TextTheme(
      displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AurixColors.textPrimary,
          letterSpacing: -0.5),
      displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AurixColors.textPrimary,
          letterSpacing: -0.3),
      displaySmall: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AurixColors.textPrimary),
      headlineLarge: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AurixColors.textPrimary),
      headlineMedium: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AurixColors.textPrimary),
      headlineSmall: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AurixColors.textPrimary),
      titleLarge: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AurixColors.textPrimary),
      titleMedium: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AurixColors.textPrimary),
      titleSmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AurixColors.textSecondary,
          letterSpacing: 0.5),
      bodyLarge: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: AurixColors.textSecondary),
      bodyMedium: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AurixColors.textSecondary),
      bodySmall: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AurixColors.textMuted),
      labelLarge: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AurixColors.textPrimary,
          letterSpacing: 0.3),
      labelMedium: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AurixColors.textSecondary,
          letterSpacing: 0.4),
      labelSmall: GoogleFonts.poppins(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AurixColors.textMuted,
          letterSpacing: 0.5),
    );
  }
}
