import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Application Theme Configuration
/// 
/// Defines light and dark themes using Material 3 design system
/// with role-specific accent colors for Admin, Landlord, and Tenant.

class AppTheme {
  // Prevent instantiation
  AppTheme._();

  // Enhanced Role-specific colors with gradients
  static const Color adminAccent = Color(0xFF4F46E5); // Indigo
  static const Color landlordAccent = Color(0xFF059669); // Emerald
  static const Color tenantAccent = Color(0xFF7C3AED); // Violet

  // Primary colors - Enhanced vibrant palette
  static const Color primaryColor = Color(0xFF4F46E5); // Indigo
  static const Color primaryLight = Color(0xFF818CF8); // Light Indigo
  static const Color secondaryColor = Color(0xFF06B6D4); // Cyan
  static const Color tertiaryColor = Color(0xFFEC4899); // Pink

  // Status colors
  static const Color errorColor = Color(0xFFDC2626); // Red
  static const Color warningColor = Color(0xFFF59E0B); // Amber
  static const Color successColor = Color(0xFF059669); // Emerald
  static const Color infoColor = Color(0xFF0EA5E9); // Sky Blue

  // Additional vibrant colors
  static const Color accentOrange = Color(0xFFEA580C); // Orange
  static const Color accentTeal = Color(0xFF14B8A6); // Teal
  static const Color accentPurple = Color(0xFFA855F7); // Purple
  // Bottom navigation blue (used for a cohesive blue nav background)
  static const Color bottomNavBlue = Color(0xFF1565C0); // Blue 800

  /// Light Theme
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      error: errorColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,

      // Typography with enhanced visual hierarchy
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF374151),
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374151),
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF374151),
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF4B5563),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF4B5563),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF6B7280),
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF9CA3AF),
        ),
      ),

      // AppBar with gradient support
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFFFAFBFC),
        foregroundColor: const Color(0xFF1F2937),
        iconTheme: const IconThemeData(color: Color(0xFF4F46E5)),
        toolbarHeight: 64,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1F2937),
        ),
      ),

      // Cards with enhanced elevation and shadow
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        surfaceTintColor: primaryColor,
      ),

      // Input fields with vibrant focus state
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Buttons with vibrant gradients
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(48, 48),
          elevation: 3,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shadowColor: primaryColor.withValues(alpha: 0.4),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: primaryColor, width: 2),
          ),
          minimumSize: const Size(48, 48),
          foregroundColor: primaryColor,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          minimumSize: const Size(48, 48),
          foregroundColor: primaryColor,
        ),
      ),

      // FAB with modern styling
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation with vibrant colors
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        elevation: 12,
        backgroundColor: bottomNavBlue,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Divider with subtle styling
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1.5,
        space: 16,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFEEF2FF),
        disabledColor: Colors.grey.shade300,
        selectedColor: primaryColor,
        secondarySelectedColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        brightness: Brightness.light,
      ),

      // Scaffold background
      scaffoldBackgroundColor: const Color(0xFFFAFBFC),
    );
  }

  /// Dark Theme
  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      error: errorColor,
      secondary: secondaryColor,
      tertiary: tertiaryColor,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,

      // Typography with enhanced visual hierarchy
      textTheme: GoogleFonts.interTextTheme(ThemeData
          .dark()
          .textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white70,
        ),
      ),

      // AppBar with gradient support
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: const Color(0xFFF9FAFB),
        iconTheme: const IconThemeData(color: Color(0xFF818CF8)),
        toolbarHeight: 64,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),

      // Cards with enhanced elevation and shadow
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        color: const Color(0xFF1E293B),
        surfaceTintColor: primaryLight,
      ),

      // Input fields with vibrant focus state
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF0F172A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade700, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade800, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryLight, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: errorColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: const TextStyle(
          color: Color(0xFF8B92A0),
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          color: primaryLight,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Buttons with vibrant gradients
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          minimumSize: const Size(48, 48),
          elevation: 3,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shadowColor: primaryColor.withValues(alpha: 0.5),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: primaryLight, width: 2),
          ),
          minimumSize: const Size(48, 48),
          foregroundColor: primaryLight,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          minimumSize: const Size(48, 48),
          foregroundColor: primaryLight,
        ),
      ),

      // FAB with modern styling
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        highlightElevation: 12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),

      // Bottom Navigation with vibrant colors
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        elevation: 12,
        backgroundColor: bottomNavBlue,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),

      // Divider with subtle styling
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade800,
        thickness: 1.5,
        space: 16,
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF312E81),
        disabledColor: Colors.grey.shade700,
        selectedColor: primaryColor,
        secondarySelectedColor: secondaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: primaryLight,
        ),
        secondaryLabelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        brightness: Brightness.dark,
      ),

      // Scaffold background
      scaffoldBackgroundColor: const Color(0xFF0F172A),
    );
  }

  /// Get role-specific accent color
  static Color getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return adminAccent;
      case 'landlord':
        return landlordAccent;
      case 'tenant':
        return tenantAccent;
      default:
        return primaryColor;
    }
  }

  /// Get role-specific gradient
  static LinearGradient getRoleGradient(String role) {
    final color = getRoleColor(role);
    return LinearGradient(
      colors: [
        color,
        color.withValues(alpha: 0.7),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  /// Get vibrant multi-color gradient
  static LinearGradient getVibrantGradient(String type) {
    switch (type.toLowerCase()) {
      case 'admin':
        return LinearGradient(
          colors: [adminAccent, const Color(0xFF312E81)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'landlord':
        return LinearGradient(
          colors: [landlordAccent, accentTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'tenant':
        return LinearGradient(
          colors: [tenantAccent, accentPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'success':
        return LinearGradient(
          colors: [successColor, accentTeal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'warning':
        return LinearGradient(
          colors: [warningColor, accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'error':
        return LinearGradient(
          colors: [errorColor, const Color(0xFFB91C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      case 'info':
        return LinearGradient(
          colors: [infoColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
      default:
        return LinearGradient(
          colors: [primaryColor, primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
    }
  }

  /// Get role-specific colors map
  static Map<String, Color> getRoleColorMap() {
    return {
      'admin': adminAccent,
      'landlord': landlordAccent,
      'tenant': tenantAccent,
      'success': successColor,
      'warning': warningColor,
      'error': errorColor,
      'info': infoColor,
    };
  }
}
