import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Brand Colors ──────────────────────────────────────────────────────────────
// All raw hex values live ONLY here — widgets consume via AppColors or colorScheme.

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // Core brand palette extracted from the PhrasePop logo
  final Color primaryPurple;
  final Color deepPurple;
  final Color cyan;
  final Color brightBlue;
  final Color magenta;
  final Color gold;
  final Color orange;
  final Color success;
  final Color danger;
  final Color backgroundDark;
  final Color cardBg;

  // Semantic aliases used across widgets
  final Color subtleText;
  final Color glowPurple; // rgba(123,63,242,0.35) — used for glow shadows

  const AppColors({
    required this.primaryPurple,
    required this.deepPurple,
    required this.cyan,
    required this.brightBlue,
    required this.magenta,
    required this.gold,
    required this.orange,
    required this.success,
    required this.danger,
    required this.backgroundDark,
    required this.cardBg,
    required this.subtleText,
    required this.glowPurple,
  });

  @override
  AppColors copyWith({
    Color? primaryPurple,
    Color? deepPurple,
    Color? cyan,
    Color? brightBlue,
    Color? magenta,
    Color? gold,
    Color? orange,
    Color? success,
    Color? danger,
    Color? backgroundDark,
    Color? cardBg,
    Color? subtleText,
    Color? glowPurple,
  }) =>
      AppColors(
        primaryPurple: primaryPurple ?? this.primaryPurple,
        deepPurple: deepPurple ?? this.deepPurple,
        cyan: cyan ?? this.cyan,
        brightBlue: brightBlue ?? this.brightBlue,
        magenta: magenta ?? this.magenta,
        gold: gold ?? this.gold,
        orange: orange ?? this.orange,
        success: success ?? this.success,
        danger: danger ?? this.danger,
        backgroundDark: backgroundDark ?? this.backgroundDark,
        cardBg: cardBg ?? this.cardBg,
        subtleText: subtleText ?? this.subtleText,
        glowPurple: glowPurple ?? this.glowPurple,
      );

  @override
  AppColors lerp(covariant ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryPurple: Color.lerp(primaryPurple, other.primaryPurple, t)!,
      deepPurple: Color.lerp(deepPurple, other.deepPurple, t)!,
      cyan: Color.lerp(cyan, other.cyan, t)!,
      brightBlue: Color.lerp(brightBlue, other.brightBlue, t)!,
      magenta: Color.lerp(magenta, other.magenta, t)!,
      gold: Color.lerp(gold, other.gold, t)!,
      orange: Color.lerp(orange, other.orange, t)!,
      success: Color.lerp(success, other.success, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      backgroundDark: Color.lerp(backgroundDark, other.backgroundDark, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      subtleText: Color.lerp(subtleText, other.subtleText, t)!,
      glowPurple: Color.lerp(glowPurple, other.glowPurple, t)!,
    );
  }
}

// ─── Design Tokens ─────────────────────────────────────────────────────────────

class AppTheme {
  AppTheme._();

  // Spacing
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Radii — very rounded for bubble/casual feel
  static const double radiusSm = 12.0;
  static const double radiusMd = 20.0;
  static const double radiusLg = 28.0;
  static const double radiusXl = 36.0;
  static const double radiusPill = 100.0;

  // Icon sizes
  static const double iconSm = 18.0;
  static const double iconMd = 24.0;
  static const double iconLg = 32.0;
  static const double iconXl = 48.0;

  // Component heights
  static const double buttonHeight = 56.0;
  static const double buttonHeightSm = 46.0;
  static const double inputHeight = 56.0;

  // Opacities
  static const double opacityDisabled = 0.38;
  static const double opacityHint = 0.6;
  static const double opacityOverlay = 0.8;
  static const double opacityGlow = 0.35; // standard glow alpha

  // Borders
  static const double borderDefault = 1.5;
  static const double borderSelected = 2.5;
  static const double borderGlow = 2.0;

  // Glow blur radii
  static const double glowBlurSm = 12.0;
  static const double glowBlurMd = 24.0;
  static const double glowBlurLg = 40.0;

  // ─── Gradients (defined here, consumed by widgets) ──────────────────────────

  /// Primary brand gradient: purple → cyan (logo's main gradient)
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7B3FF2), Color(0xFF35D6FF)],
  );

  /// Secondary: orange → gold
  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF9F1C), Color(0xFFFFD93D)],
  );

  /// Accent: magenta → purple
  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFD946EF), Color(0xFF7B3FF2)],
  );

  /// Success: green glow
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
  );

  /// Danger: red/pink
  static const LinearGradient dangerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFF4D6D), Color(0xFFD946EF)],
  );

  // ─── Single ThemeData (dark neon) ───────────────────────────────────────────

  static final ThemeData darkTheme = _buildTheme();

  static ThemeData _buildTheme() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF7B3FF2),
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF381B8F),
      onPrimaryContainer: Colors.white,
      secondary: Color(0xFF35D6FF),
      onSecondary: Color(0xFF0E1022),
      secondaryContainer: Color(0xFF1A1F3A),
      onSecondaryContainer: Colors.white,
      tertiary: Color(0xFFD946EF),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF2A1040),
      onTertiaryContainer: Colors.white,
      error: Color(0xFFFF4D6D),
      onError: Colors.white,
      surface: Color(0xFF1A1F3A),
      onSurface: Colors.white,
      onSurfaceVariant: Color(0xFFB0B8D1),
      outline: Color(0xFF7B3FF2),
      outlineVariant: Color(0xFF2E3456),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: Colors.white,
      onInverseSurface: Color(0xFF0E1022),
      inversePrimary: Color(0xFF7B3FF2),
      surfaceContainerHighest: Color(0xFF242A4A),
      surfaceContainerHigh: Color(0xFF1E2440),
      surfaceContainer: Color(0xFF1A1F3A),
      surfaceContainerLow: Color(0xFF161B35),
      surfaceContainerLowest: Color(0xFF0E1022),
    );

    final appColors = const AppColors(
      primaryPurple: Color(0xFF7B3FF2),
      deepPurple: Color(0xFF381B8F),
      cyan: Color(0xFF35D6FF),
      brightBlue: Color(0xFF00B7FF),
      magenta: Color(0xFFD946EF),
      gold: Color(0xFFFFD93D),
      orange: Color(0xFFFF9F1C),
      success: Color(0xFF22C55E),
      danger: Color(0xFFFF4D6D),
      backgroundDark: Color(0xFF0E1022),
      cardBg: Color(0xFF1A1F3A),
      subtleText: Color(0xFF8896BB),
      glowPurple: Color(0x597B3FF2),
    );

    final textTheme = _buildTextTheme(colorScheme);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0E1022),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1F3A),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1A1F3A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF2E3456), width: borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF2E3456), width: borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFF7B3FF2), width: borderGlow),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        hintStyle: textTheme.bodyMedium?.copyWith(color: const Color(0xFF8896BB)),
        labelStyle: textTheme.bodyMedium,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1A1F3A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusPill),
        ),
        labelStyle: textTheme.labelMedium,
        side: const BorderSide(color: Color(0xFF2E3456)),
      ),
      extensions: [appColors],
    );
  }

  static TextTheme _buildTextTheme(ColorScheme colorScheme) {
    // Poppins ExtraBold for headings — thick rounded premium feel matching logo typography
    final base = GoogleFonts.poppinsTextTheme();
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(
        fontWeight: FontWeight.w900,
        color: Colors.white,
        letterSpacing: -1,
      ),
      headlineLarge: base.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        color: Colors.white,
        letterSpacing: -0.5,
      ),
      headlineMedium: base.headlineMedium?.copyWith(
        fontWeight: FontWeight.w800,
        color: Colors.white,
      ),
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      titleSmall: base.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        color: Colors.white,
      ),
      bodyMedium: base.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      bodySmall: base.bodySmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      labelLarge: base.labelLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: Colors.white,
        letterSpacing: 0.5,
        fontSize: 15,
      ),
      labelMedium: base.labelMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: colorScheme.onSurfaceVariant,
      ),
      labelSmall: base.labelSmall?.copyWith(
        color: colorScheme.onSurfaceVariant,
        letterSpacing: 0.5,
      ),
    );
  }
}
