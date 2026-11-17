import 'package:flutter/widgets.dart';

import 'cool_icons_theme_data.dart';

/// Applies a Coolicons configuration to a subtree.
///
/// This is useful when one section of a screen needs a different icon style
/// from the app-wide [CoolIconsThemeData].
class CoolIconTheme extends InheritedTheme {
  /// Creates a local Coolicons theme.
  const CoolIconTheme({super.key, required this.data, required super.child});

  /// The configuration inherited by descendant [CoolIcon] widgets.
  final CoolIconsThemeData data;

  /// Returns the nearest local Coolicons theme, if one exists.
  static CoolIconsThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CoolIconTheme>()?.data;
  }

  @override
  bool updateShouldNotify(CoolIconTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return CoolIconTheme(data: data, child: child);
  }
}
