import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;

  static const EdgeInsets paddingXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingMd = EdgeInsets.all(md);
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);
}

class AppRadius {
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double circular = 100.0;
}

// =============================================================================
// COLORS
// =============================================================================

class RomanticColors {
  // Primary: Soft Coral/Pink
  static const primary = Color(0xFFF08A8A); // Soft Coral
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFFFFD6D6);
  static const onPrimaryContainer = Color(0xFF5C1B1B);

  // Secondary: Sage Green
  static const secondary = Color(0xFF8DA399); // Sage Green
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFDAEBE3);
  static const onSecondaryContainer = Color(0xFF2A3D35);

  // Tertiary: Gentle Yellow (for sunflowers/accents)
  static const tertiary = Color(0xFFE8D385);
  static const onTertiary = Color(0xFF453A0F);

  // Backgrounds
  static const background = Color(0xFFFFF9F5); // Warm creamy white
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF4EBE6);
  static const onSurface = Color(0xFF4A403A); // Warm dark grey/brown
  static const onSurfaceVariant = Color(0xFF8C7F78);

  static const outline = Color(0xFFD4C5BE);
}

// =============================================================================
// THEMES
// =============================================================================

ThemeData get romanticTheme => ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: RomanticColors.primary,
        onPrimary: RomanticColors.onPrimary,
        primaryContainer: RomanticColors.primaryContainer,
        onPrimaryContainer: RomanticColors.onPrimaryContainer,
        secondary: RomanticColors.secondary,
        onSecondary: RomanticColors.onSecondary,
        secondaryContainer: RomanticColors.secondaryContainer,
        onSecondaryContainer: RomanticColors.onSecondaryContainer,
        tertiary: RomanticColors.tertiary,
        onTertiary: RomanticColors.onTertiary,
        error: const Color(0xFFBA1A1A),
        onError: Colors.white,
        surface: RomanticColors.surface,
        onSurface: RomanticColors.onSurface,
        surfaceContainerHighest: RomanticColors.surfaceVariant,
        onSurfaceVariant: RomanticColors.onSurfaceVariant,
        outline: RomanticColors.outline,
        inversePrimary: const Color(0xFFE6B8B8),
      ),
      scaffoldBackgroundColor: RomanticColors.background,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: RomanticColors.primary.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        color: RomanticColors.surface,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.circular)),
        ),
      ),
      textTheme: _buildTextTheme(),
    );

TextTheme _buildTextTheme() {
  final displayFont = GoogleFonts.playfairDisplay;
  final bodyFont = GoogleFonts.lato;

  return TextTheme(
    displayLarge: displayFont(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: RomanticColors.onSurface),
    displayMedium: displayFont(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: RomanticColors.onSurface),
    displaySmall: displayFont(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: RomanticColors.onSurface),
    headlineLarge: displayFont(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: RomanticColors.onSurface),
    headlineMedium: displayFont(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: RomanticColors.onSurface),
    headlineSmall: displayFont(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: RomanticColors.onSurface),
    titleLarge: displayFont(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: RomanticColors.onSurface),
    titleMedium: bodyFont(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        color: RomanticColors.onSurface),
    titleSmall: bodyFont(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: RomanticColors.onSurface),
    bodyLarge: bodyFont(
        fontSize: 16, letterSpacing: 0.5, color: RomanticColors.onSurface),
    bodyMedium: bodyFont(
        fontSize: 14, letterSpacing: 0.25, color: RomanticColors.onSurface),
    bodySmall: bodyFont(
        fontSize: 12, letterSpacing: 0.4, color: RomanticColors.onSurface),
    labelLarge: bodyFont(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        color: RomanticColors.onSurface),
  );
}
