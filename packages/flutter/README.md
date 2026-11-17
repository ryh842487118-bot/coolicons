# Coolicons for Flutter

A community-maintained Flutter adapter for the [Coolicons](https://coolicons.cool/) icon set.

> This package is not an official Flutter package published by the upstream Coolicons author.

## Attribution and license

- Icon artwork: [Coolicons](https://github.com/krystonschwarze/coolicons), by Kryston Schwarze.
- Upstream license: MIT. The upstream copyright and license notice are retained in this repository.
- Flutter adapter: maintained in this fork under the MIT License.
- Upstream source and update history: https://github.com/krystonschwarze/coolicons

See [NOTICE.md](NOTICE.md) for the source and attribution details.

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

The complete `CoolIcons` catalog is generated from the upstream SVG source.
When developing from this monorepo, run the generator from the repository root:

```sh
node scripts/build-flutter.mjs
```

## Global theme

Configure the defaults once. Individual icon arguments override the theme.

```dart
MaterialApp(
  theme: ThemeData(
    brightness: Brightness.light,
    extensions: const [
      CoolIconsThemeData(
        style: CoolIconStyle.line,
        radius: CoolIconRadius.round,
        size: 24,
        color: Color(0xFF333333),
        strokeWidth: 2,
      ),
    ],
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
    extensions: const [
      CoolIconsThemeData(
        style: CoolIconStyle.line,
        radius: CoolIconRadius.round,
        size: 24,
        color: Color(0xFFF5F5F5),
        strokeWidth: 2,
      ),
    ],
  ),
  themeMode: ThemeMode.system,
  home: const MyHomePage(),
);
```

If `color` is omitted from `CoolIconsThemeData`, the widget inherits
`IconTheme` and then `ColorScheme.onSurface`.

## Local theme

```dart
CoolIconTheme(
  data: const CoolIconsThemeData(
    style: CoolIconStyle.fill,
    radius: CoolIconRadius.round,
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

## Per-icon overrides

```dart
CoolIcon(
  CoolIcons.heart,
  style: CoolIconStyle.fill,
  color: Colors.red,
  size: 32,
)
```

## Supported options

| Option | Source / behavior |
| --- | --- |
| `style` | Selects one of the upstream Line, Duocolor, Duotone, Fill or Bulk SVG variants. |
| `radius` | Selects the upstream Sharp, Regular or Round SVG variant. |
| `size` | Sets the rendered width and height. |
| `color` | Supplies SVG `currentColor` through `SvgTheme`. |
| `strokeWidth` | Overrides `stroke-width` in stroked SVG variants. |
| `secondaryColor` | Overrides the color of the lower-opacity SVG layer, where present. |
| `secondaryOpacity` | Overrides the opacity of the lower-opacity SVG layer, where present. |

Fill and Bulk artwork has no stroke, so `strokeWidth` does not affect those styles.

## Upstream updates

The icon catalog is generated from `icons/manifest.json` and `icons/svg/`.
After syncing the upstream repository, run `node scripts/build-flutter.mjs`
to regenerate the Dart catalog.

## License

The icon artwork and this Flutter adapter are distributed under the MIT License.
See the repository's [LICENSE](../../LICENSE) and [NOTICE.md](NOTICE.md).
