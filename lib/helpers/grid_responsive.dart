// lib/helpers/grid_responsive.dart
import 'package:flutter/foundation.dart';

@immutable
class GridResponsive {
  const GridResponsive._();

  // Breakpoints aligned with app usage
  static const double bpSm = 600;
  static const double bpMd = 900;
  static const double bpLg = 1200;

  /// Columns based on width & min tile width; capped by breakpoints.
  static int columnsForWidth(
    double width, {
    double minTileWidth = 180,
    int maxXs = 2,
    int maxSm = 3,
    int maxMd = 4,
    int maxLg = 5,
  }) {
    final byBp = width >= bpLg
        ? maxLg
        : width >= bpMd
            ? maxMd
            : width >= bpSm
                ? maxSm
                : maxXs;
    final int byMin = width ~/ minTileWidth.clamp(140, 280);
    return byMin.clamp(1, byBp);
  }

  /// Aspect ratio per breakpoint; returns [fallback] if disabled.
  static double aspectRatioForWidth(
    double width, {
    bool useResponsiveAspectRatio = true,
    double fallback = 0.62,
  }) {
    if (!useResponsiveAspectRatio) return fallback;
    if (width >= bpLg) return 0.72;
    if (width >= bpMd) return 0.70;
    if (width >= bpSm) return 0.68;
    return fallback;
  }
}
