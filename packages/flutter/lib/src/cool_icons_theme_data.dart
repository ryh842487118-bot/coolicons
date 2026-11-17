import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'cool_icon_radius.dart';
import 'cool_icon_style.dart';

/// Global default configuration for Coolicons widgets.
///
/// Add this extension to both [ThemeData.extensions] and
/// [ThemeData.darkTheme.extensions] to define light and dark defaults.
/// A null [color] inherits from [IconTheme] and then [ColorScheme.onSurface].
@immutable
class CoolIconsThemeData extends ThemeExtension<CoolIconsThemeData> {
  /// Creates the default Coolicons configuration.
  const CoolIconsThemeData({
    this.style = CoolIconStyle.line,
    this.radius = CoolIconRadius.round,
    this.size = 24,
    this.color,
    this.strokeWidth = 2,
    this.secondaryColor,
    this.secondaryOpacity,
  });

  /// Default artwork style.
  final CoolIconStyle style;

  /// Default artwork corner treatment.
  final CoolIconRadius radius;

  /// Default icon width and height in logical pixels.
  final double size;

  /// Default primary color. Null inherits from [IconTheme] or [ColorScheme].
  final Color? color;

  /// Default stroke width for stroked styles. Fill and Bulk have no stroke.
  final double strokeWidth;

  /// Optional color for the lower-opacity layer in Duocolor, Duotone and Bulk.
  final Color? secondaryColor;

  /// Optional opacity for the lower-opacity layer in Duocolor, Duotone and Bulk.
  final double? secondaryOpacity;

  /// Creates a copy with the provided values replaced.
  CoolIconsThemeData copyWith({
    CoolIconStyle? style,
    CoolIconRadius? radius,
    double? size,
    Color? color,
    bool clearColor = false,
    double? strokeWidth,
    Color? secondaryColor,
    bool clearSecondaryColor = false,
    double? secondaryOpacity,
    bool clearSecondaryOpacity = false,
  }) {
    return CoolIconsThemeData(
      style: style ?? this.style,
      radius: radius ?? this.radius,
      size: size ?? this.size,
      color: clearColor ? null : (color ?? this.color),
      strokeWidth: strokeWidth ?? this.strokeWidth,
      secondaryColor: clearSecondaryColor
          ? null
          : (secondaryColor ?? this.secondaryColor),
      secondaryOpacity: clearSecondaryOpacity
          ? null
          : (secondaryOpacity ?? this.secondaryOpacity),
    );
  }

  @override
  CoolIconsThemeData lerp(
    covariant CoolIconsThemeData? other,
    double t,
  ) {
    if (other == null) return this;
    return CoolIconsThemeData(
      style: t < 0.5 ? style : other.style,
      radius: t < 0.5 ? radius : other.radius,
      size: lerpDouble(size, other.size, t)!,
      color: Color.lerp(color, other.color, t),
      strokeWidth: lerpDouble(strokeWidth, other.strokeWidth, t)!,
      secondaryColor: Color.lerp(secondaryColor, other.secondaryColor, t),
      secondaryOpacity: _lerpNullable(
        secondaryOpacity,
        other.secondaryOpacity,
        t,
      ),
    );
  }

  static double? _lerpNullable(double? a, double? b, double t) {
    if (a == null && b == null) return null;
    return lerpDouble(a ?? b!, b ?? a!, t);
  }

  @override
  bool operator ==(Object other) {
    return other is CoolIconsThemeData &&
        other.style == style &&
        other.radius == radius &&
        other.size == size &&
        other.color == color &&
        other.strokeWidth == strokeWidth &&
        other.secondaryColor == secondaryColor &&
        other.secondaryOpacity == secondaryOpacity;
  }

  @override
  int get hashCode => Object.hash(
        style,
        radius,
        size,
        color,
        strokeWidth,
        secondaryColor,
        secondaryOpacity,
      );
}
