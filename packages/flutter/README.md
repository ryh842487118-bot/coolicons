# Coolicons for Flutter

**Requirements:** Flutter 3.47+ and Dart 3.13+. The package uses Flutter's standalone `material_ui` package for `ThemeExtension` integration.

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
import 'package:material_ui/material_ui.dart';

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

The fork checks the upstream Coolicons repository daily and opens a pull request
when new commits are available. The sync workflow also aligns the Flutter
pubspec version and changelog with the upstream monorepo release.

After merging an upstream sync pull request, the Flutter package workflow
regenerates the Dart catalog from `icons/manifest.json` and `icons/svg/`,
then runs formatting, analysis and tests. To generate locally, run
`node scripts/build-flutter.mjs` from the repository root.

## License

The icon artwork and this Flutter adapter are distributed under the MIT License.
See the repository's [LICENSE](../../LICENSE) and [NOTICE.md](NOTICE.md).

## Versioning and releases

The Flutter adapter follows the same version and Git tag as the upstream Coolicons
monorepo packages. The version is updated by `scripts/release.mjs` and checked
by `scripts/release-check.mjs`; it is not versioned independently.

The release workflow runs the Flutter generator, analyzer, tests and
`flutter pub publish --dry-run` alongside the existing monorepo checks.

### First pub.dev publication

pub.dev requires the first version of a package to be published manually.
After publishing the first version, enable automated publishing on the package's
pub.dev Admin page with:

- GitHub repository: `ryh842487118-bot/coolicons`
- Tag pattern: `v{{version}}`

After the first publication and Trusted Publisher setup, a change to the shared
monorepo version on `main` automatically creates the matching `vX.Y.Z` tag.
The tag push triggers the release workflow, and the `publish-flutter` job
publishes this package to pub.dev using OIDC.

For automatic tag creation, add a GitHub Actions repository secret named
`RELEASE_TOKEN`. Use a fine-grained token scoped to this repository with
Contents: Read and write permission. This token only pushes the version tag;
pub.dev publishing itself uses short-lived OIDC credentials, not a pub.dev
token stored in GitHub secrets.

This fork publishes only `coolicons_flutter` to pub.dev; it does not republish
the upstream React, Vue, SVG, CLI or MCP npm packages, and does not publish the
upstream MCP registry entry.

The Flutter package shares the monorepo release number (for example, 5.4.0),
but remains a separate package on pub.dev.
