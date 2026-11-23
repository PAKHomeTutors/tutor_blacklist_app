import 'package:flutter/material.dart';

/// Central place for all custom semantic colors used across the app.
/// Keeping these here makes it trivial to swap themes later without
/// hunting for hard-coded hex values.
class AppColors {
  AppColors._();

  // --- Brand ---
  static const Color primaryBlue = Color(0xFF0D47A1); // Deep Blue
  static const Color primaryBlueLight = Color(0xFF5472D3);
  static const Color primaryBlueDark = Color(0xFF002171);

  // --- List status colors ---
  static const Color blacklisted = Color(0xFFD32F2F); // Red
  static const Color greylisted = Color(0xFFF57C00);  // Orange
  static const Color greenlisted = Color(0xFF2E7D32); // Green
  static const Color unverified = Color(0xFF757575);  // Grey

  // --- Tints (used for chip backgrounds / light surfaces) ---
  static const Color blacklistedTint = Color(0xFFFDECEA);
  static const Color greylistedTint = Color(0xFFFFF3E0);
  static const Color greenlistedTint = Color(0xFFE8F5E9);
  static const Color unverifiedTint = Color(0xFFF5F5F5);

  // --- Dark mode tints (subtle) ---
  static const Color blacklistedTintDark = Color(0xFF3E1C1C);
  static const Color greylistedTintDark = Color(0xFF3E2A10);
  static const Color greenlistedTintDark = Color(0xFF1B3A1C);
  static const Color unverifiedTintDark = Color(0xFF2A2A2A);
}