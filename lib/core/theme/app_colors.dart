import 'package:flutter/material.dart';

/// App Color Palette for Ramtex B2B E-commerce
/// 
/// Professional, enterprise-grade color scheme as specified in user requirements.
/// Primary: #f7f7f7 (Light gray background)
class AppColors {
  AppColors._();

  // ============================================
  // PRIMARY COLORS
  // ============================================
  
  /// Primary background color - Light gray
  static const Color primary = Color(0xFFF7F7F7);
  
  /// Primary variant - Slightly darker
  static const Color primaryVariant = Color(0xFFE8E8E8);
  
  /// Primary dark - For contrast
  static const Color primaryDark = Color(0xFFD0D0D0);

  // ============================================
  // ACCENT / BRAND COLORS
  // ============================================
  
  /// Accent color - Professional blue
  static const Color accent = Color(0xFF2563EB);
  
  /// Accent variant
  static const Color accentVariant = Color(0xFF1D4ED8);
  
  /// Accent light
  static const Color accentLight = Color(0xFFDBEAFE);

  // ============================================
  // NEUTRAL COLORS
  // ============================================
  
  /// Pure white
  static const Color white = Color(0xFFFFFFFF);
  
  /// Pure black
  static const Color black = Color(0xFF000000);
  
  /// Background color
  static const Color background = Color(0xFFF7F7F7);
  
  /// Surface color (cards, sheets)
  static const Color surface = Color(0xFFFFFFFF);
  
  /// Scaffold background
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  // ============================================
  // TEXT COLORS
  // ============================================
  
  /// Primary text - Dark gray
  static const Color textPrimary = Color(0xFF1F2937);
  
  /// Secondary text - Medium gray
  static const Color textSecondary = Color(0xFF6B7280);
  
  /// Tertiary text - Light gray
  static const Color textTertiary = Color(0xFF9CA3AF);
  
  /// Disabled text
  static const Color textDisabled = Color(0xFFD1D5DB);

  // ============================================
  // STATUS COLORS
  // ============================================
  
  /// Success - Green
  static const Color success = Color(0xFF10B981);
  
  /// Success light background
  static const Color successLight = Color(0xFFD1FAE5);
  
  /// Warning - Amber
  static const Color warning = Color(0xFFF59E0B);
  
  /// Warning light background
  static const Color warningLight = Color(0xFFFEF3C7);
  
  /// Error - Red
  static const Color error = Color(0xFFEF4444);
  
  /// Error light background  
  static const Color errorLight = Color(0xFFFEE2E2);
  
  /// Info - Blue
  static const Color info = Color(0xFF3B82F6);
  
  /// Info light background
  static const Color infoLight = Color(0xFFDBEAFE);

  // ============================================
  // BORDER & DIVIDER COLORS
  // ============================================
  
  /// Border color - Light gray
  static const Color border = Color(0xFFE5E7EB);
  
  /// Divider color
  static const Color divider = Color(0xFFF3F4F6);

  // ============================================
  // SHADOW & OVERLAY
  // ============================================
  
  /// Shadow color
  static const Color shadow = Color(0x1A000000);
  
  /// Overlay color (for modals)
  static const Color overlay = Color(0x80000000);

  // ============================================
  // GRADIENT COLORS (for premium feel)
  // ============================================
  
  /// Primary gradient
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF7C3AED),
    ],
  );

  /// Subtle gradient for cards
  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF7F7F7),
    ],
  );
}
