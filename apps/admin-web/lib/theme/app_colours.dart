import 'package:flutter/material.dart';

/// Central color palette for the Smart Parking admin panel.
/// Kept minimal and status-driven, matching the slot-map mockup:
/// 🟢 available · 🔴 occupied · 🟠 reserved · ⚪ maintenance
class AppColors {
  AppColors._();

  // Base surfaces
  static const Color background = Color(0xFFF6F7F9);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceAlt = Color(0xFFF0F1F4);
  static const Color border = Color(0xFFE3E5E9);

  // Text
  static const Color textPrimary = Color(0xFF1C1E21);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF9CA3AF);

  // Brand / primary
  static const Color primary = Color(0xFF2F6FED);
  static const Color primaryDark = Color(0xFF1E4FBE);
  static const Color primarySoft = Color(0xFFEAF1FE);

  // Slot status colors (single source of truth — used everywhere)
  static const Color available = Color(0xFF22C55E);
  static const Color availableSoft = Color(0xFFE7F9EE);

  static const Color occupied = Color(0xFFEF4444);
  static const Color occupiedSoft = Color(0xFFFDEAEA);

  static const Color reserved = Color(0xFFF59E0B);
  static const Color reservedSoft = Color(0xFFFEF3DD);

  static const Color maintenance = Color(0xFF9CA3AF);
  static const Color maintenanceSoft = Color(0xFFF0F1F2);

  /// Convenience: map a [SlotStatus] to its solid color.
  static Color forStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return available;
      case SlotStatus.occupied:
        return occupied;
      case SlotStatus.reserved:
        return reserved;
      case SlotStatus.maintenance:
        return maintenance;
    }
  }

  /// Convenience: map a [SlotStatus] to its soft/background color.
  static Color softForStatus(SlotStatus status) {
    switch (status) {
      case SlotStatus.available:
        return availableSoft;
      case SlotStatus.occupied:
        return occupiedSoft;
      case SlotStatus.reserved:
        return reservedSoft;
      case SlotStatus.maintenance:
        return maintenanceSoft;
    }
  }
}

/// Shared enum used by all slot/parking widgets.
enum SlotStatus { available, occupied, reserved, maintenance }

extension SlotStatusLabel on SlotStatus {
  String get label {
    switch (this) {
      case SlotStatus.available:
        return 'Available';
      case SlotStatus.occupied:
        return 'Occupied';
      case SlotStatus.reserved:
        return 'Reserved';
      case SlotStatus.maintenance:
        return 'Maintenance';
    }
  }
}
