import 'package:flutter/material.dart';

/// Centralized animation constants for the application.
class AppAnimations {
  // Durations
  static const Duration shortDuration = Duration(milliseconds: 250);
  static const Duration mediumDuration = Duration(milliseconds: 400);
  static const Duration longDuration = Duration(milliseconds: 600);

  // Curves
  static const Curve primaryCurve = Curves.easeInOut;
  static const Curve secondaryCurve = Curves.easeOut;
}
