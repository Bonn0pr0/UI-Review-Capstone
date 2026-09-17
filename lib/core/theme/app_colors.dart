import 'package:flutter/material.dart';

class AppColors {
  // Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceHover = Color(0xFFF1F5F9);
  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color divider = Color(0xFFE2E8F0);

  // Primary Palette (Vibrant Modern Blue)
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryHover = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Secondary / Accent Teal
  static const Color accentTeal = Color(0xFF14B8A6);
  static const Color accentTealLight = Color(0xFFF0FDFA);

  // Text Colors
  static const Color textHeading = Color(0xFF0F172A); // Dark Slate
  static const Color textBody = Color(0xFF64748B);    // Gray
  static const Color textMuted = Color(0xFF94A3B8);   // Light Slate
  static const Color textDark = Color(0xFF1E293B);

  // Status Colors: Approved / Success (Soft Green)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFECFDF5);
  static const Color successBorder = Color(0xFFA7F3D0);

  // Status Colors: Need Revision / Warning (Amber/Orange)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);
  static const Color warningBorder = Color(0xFFFDE68A);

  // Status Colors: Error / Destructive / Rejected (Rose/Red)
  static const Color error = Color(0xFFF43F5E);
  static const Color errorLight = Color(0xFFFFF1F2);
  static const Color errorBorder = Color(0xFFFECDD3);

  // Status Colors: In Review / Pending (Indigo/Blue)
  static const Color pending = Color(0xFF6366F1);
  static const Color pendingLight = Color(0xFFEEF2FF);
  static const Color pendingBorder = Color(0xFFC7D2FE);

  // Sidebar specific
  static const Color sidebarBg = Color(0xFFFFFFFF);
  static const Color sidebarItemHover = Color(0xFFF8FAFC);
  static const Color sidebarActiveBg = Color(0xFFEFF6FF);

  // Shadows
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.02),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  static List<BoxShadow> get modalShadow => [
        BoxShadow(
          color: const Color(0xFF0F172A).withValues(alpha: 0.12),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}
