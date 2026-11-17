import 'cool_icon_radius.dart';
import 'cool_icon_style.dart';

/// Data for one Coolicons glyph and its available SVG variants.
class CoolIconData {
  /// Creates data for a Coolicons glyph.
  ///
  /// [variants] is keyed by "<style>/<radius>", for example "line/round".
  const CoolIconData({
    required this.name,
    required this.variants,
  });

  /// The upstream kebab-case icon name.
  final String name;

  /// The SVG source for each style and radius combination.
  final Map<String, String> variants;

  /// Returns the SVG for [style] and [radius].
  String svgFor(CoolIconStyle style, CoolIconRadius radius) {
    final key = '${style.name}/${radius.name}';
    final svg = variants[key];
    if (svg == null) {
      throw StateError('Coolicons icon "$name" has no variant "$key".');
    }
    return svg;
  }

  @override
  String toString() => 'CoolIconData($name)';
}
