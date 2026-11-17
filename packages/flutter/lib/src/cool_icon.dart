// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'cool_icon_data.dart';
import 'cool_icon_corners.dart';
import 'cool_icon_style.dart';
import 'cool_icon_theme.dart';
import 'cool_icons_theme_data.dart';

/// Renders a Coolicons glyph using its SVG artwork.
class CoolIcon extends StatelessWidget {
  /// Creates a Coolicons icon.
  const CoolIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.style,
    CoolIconCorners? corners,
    @Deprecated('Use corners instead.') CoolIconCorners? radius,
    this.strokeWidth,
    this.secondaryColor,
    this.secondaryOpacity,
    this.semanticLabel,
  }) : assert(corners == null || radius == null),
       corners = corners ?? radius;

  /// The icon artwork to render.
  final CoolIconData icon;

  /// Width and height in logical pixels. Defaults to the nearest theme.
  final double? size;

  /// Primary icon color. Defaults to the nearest Coolicons/Flutter theme.
  final Color? color;

  /// SVG artwork style. Defaults to the nearest Coolicons theme.
  final CoolIconStyle? style;

  /// SVG corner treatment. Defaults to the nearest Coolicons theme.
  final CoolIconCorners? corners;

  /// Legacy alias for [corners].
  @Deprecated('Use corners instead.')
  CoolIconCorners? get radius => corners;

  /// Stroke width for Line, Duocolor and Duotone variants.
  final double? strokeWidth;

  /// Color for the lower-opacity SVG layer, when the selected artwork has one.
  final Color? secondaryColor;

  /// Opacity for the lower-opacity SVG layer, when the selected artwork has one.
  final double? secondaryOpacity;

  /// Optional accessible label. Null icons are excluded from semantics.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final config =
        CoolIconTheme.maybeOf(context) ??
        theme.extension<CoolIconsThemeData>() ??
        const CoolIconsThemeData();
    final inheritedIconTheme = IconTheme.of(context);

    final resolvedSize = size ?? config.size;
    final resolvedColor =
        color ??
        config.color ??
        inheritedIconTheme.color ??
        theme.colorScheme.onSurface;
    final resolvedStyle = style ?? config.style;
    final resolvedCorners = corners ?? config.corners;
    final resolvedStrokeWidth = strokeWidth ?? config.strokeWidth;
    final resolvedSecondaryColor = secondaryColor ?? config.secondaryColor;
    final resolvedSecondaryOpacity =
        secondaryOpacity ?? config.secondaryOpacity;

    final source = icon.svgFor(resolvedStyle, resolvedCorners);
    final svg = _resolveSvg(
      source,
      strokeWidth: resolvedStrokeWidth,
      secondaryColor: resolvedSecondaryColor,
      secondaryOpacity: resolvedSecondaryOpacity,
    );

    return SvgPicture.string(
      svg,
      width: resolvedSize,
      height: resolvedSize,
      fit: BoxFit.contain,
      theme: SvgTheme(currentColor: resolvedColor),
      semanticsLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
    );
  }
}

String _resolveSvg(
  String source, {
  required double strokeWidth,
  Color? secondaryColor,
  double? secondaryOpacity,
}) {
  var svg = source;

  if (strokeWidth != 2) {
    svg = svg.replaceAllMapped(
      RegExp(r'stroke-width="[^"]+"'),
      (_) => 'stroke-width="$strokeWidth"',
    );
  }

  if (secondaryColor == null && secondaryOpacity == null) {
    return svg;
  }

  final pathPattern = RegExp(r'<path\b[^>]*/>');
  final opacityPattern = RegExp(r'((?:stroke|fill)-opacity=")([^"]+)(")');

  return svg.replaceAllMapped(pathPattern, (match) {
    var path = match.group(0)!;
    final opacityMatch = opacityPattern.firstMatch(path);
    if (opacityMatch == null) return path;

    if (secondaryColor != null) {
      path = path.replaceFirst('currentColor', _toSvgRgb(secondaryColor));
    }

    final alpha = secondaryColor == null ? 1.0 : _colorOpacity(secondaryColor);
    if (secondaryOpacity != null || alpha < 1) {
      final originalOpacity = double.tryParse(opacityMatch.group(2)!) ?? 1;
      final baseOpacity = secondaryOpacity ?? originalOpacity;
      final nextOpacity = (baseOpacity * alpha).clamp(0.0, 1.0);
      path = path.replaceFirstMapped(
        opacityPattern,
        (opacity) => '${opacity.group(1)}$nextOpacity${opacity.group(3)}',
      );
    }

    return path;
  });
}

String _toSvgRgb(Color color) {
  final argb = color.toARGB32();
  final red = (argb >> 16) & 0xFF;
  final green = (argb >> 8) & 0xFF;
  final blue = argb & 0xFF;
  return 'rgb($red,$green,$blue)';
}

double _colorOpacity(Color color) {
  final alpha = (color.toARGB32() >> 24) & 0xFF;
  return alpha / 255;
}
