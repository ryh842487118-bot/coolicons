# Coolicons for Flutter

A Flutter widget package for the [Coolicons](https://coolicons.cool/) icon set.

**Requirements:** Flutter 3.41+ and Dart 3.11+.

This is a community-maintained Flutter adapter. It is not an official package published by the original Coolicons author.

## Installation

```sh
flutter pub add coolicons_flutter
```

## Usage

```dart
import 'package:coolicons_flutter/coolicons_flutter.dart';

CoolIcon(CoolIcons.house);
CoolIcon(CoolIcons.heart, style: CoolIconStyle.fill);
```

## Icon styles and corners

Every icon is available in five visual styles:

- `line`
- `duocolor`
- `duotone`
- `fill`
- `bulk`

Each style supports three corner treatments:

- `sharp`
- `regular`
- `round`

```dart
CoolIcon(
  CoolIcons.heart,
  style: CoolIconStyle.fill,
  corners: CoolIconCorners.round,
  size: 32,
  color: Colors.red,
)
```

## Global theme

Set default icon appearance through Flutter's `ThemeData`. Per-icon properties override the theme.

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [
      CoolIconsThemeData(
        style: CoolIconStyle.line,
        corners: CoolIconCorners.round,
        size: 24,
        color: Color(0xFF333333),
        strokeWidth: 2,
      ),
    ],
  ),
  home: const MyHomePage(),
)
```

If `color` is not set, the icon inherits from `IconTheme`, then `ColorScheme.onSurface`.

## Local theme

Use `CoolIconTheme` to apply different defaults to part of the widget tree.

```dart
CoolIconTheme(
  data: const CoolIconsThemeData(
    style: CoolIconStyle.fill,
    corners: CoolIconCorners.round,
    size: 28,
    color: Color(0xFF222222),
  ),
  child: const Row(
    children: [
      CoolIcon(CoolIcons.house),
      CoolIcon(CoolIcons.heart),
    ],
  ),
)
```

## Supported properties

| Property | Description |
| --- | --- |
| `style` | Selects Line, Duocolor, Duotone, Fill or Bulk artwork. |
| `corners` | Selects Sharp, Regular or Round corners. |
| `size` | Icon width and height in logical pixels. |
| `color` | Primary icon color. |
| `strokeWidth` | Stroke width for Line, Duocolor and Duotone. |
| `secondaryColor` | Color of the lower-opacity SVG layer, when present. |
| `secondaryOpacity` | Opacity of the lower-opacity SVG layer, when present. |
| `semanticLabel` | Optional accessibility label. |

Fill and Bulk artwork has no stroke, so `strokeWidth` does not affect those styles.

## Icon source and author

The icon artwork comes from **Coolicons**, created by [Kryston Schwarze](https://krystonschwarze.com).

- Website: [coolicons.cool](https://coolicons.cool/)
- Original repository: [github.com/krystonschwarze/coolicons](https://github.com/krystonschwarze/coolicons)
- Original project license: MIT

This Flutter adapter is maintained separately by the community and is also distributed under the MIT License. See [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md) for attribution details.
