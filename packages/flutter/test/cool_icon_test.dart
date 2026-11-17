import 'package:coolicons_flutter/coolicons_flutter.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders an icon from its default variant', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Center(child: CoolIcon(CoolIcons.house))),
    );

    await tester.pumpAndSettle();

    expect(find.byType(CoolIcon), findsOneWidget);
    expect(
      find.byWidgetPredicate((widget) => widget is SvgPicture),
      findsOneWidget,
    );
  });

  testWidgets('uses the nearest Coolicons theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          extensions: const [
            CoolIconsThemeData(
              size: 36,
              style: CoolIconStyle.line,
              corners: CoolIconCorners.round,
              color: Colors.purple,
            ),
          ],
        ),
        home: const Center(child: CoolIcon(CoolIcons.heart)),
      ),
    );

    await tester.pumpAndSettle();

    final picture = tester.widget<SvgPicture>(
      find.byWidgetPredicate((widget) => widget is SvgPicture),
    );
    expect(picture.width, 36);
    expect(picture.height, 36);
  });
  test('generated catalog contains every style and corners for every icon', () {
    expect(CoolIcons.all.keys.toSet(), CoolIcons.names.toSet());
    expect(CoolIcons.all, isNotEmpty);

    for (final entry in CoolIcons.all.entries) {
      expect(CoolIcons.all.containsKey(entry.value.name), isTrue);
      for (final style in CoolIconStyle.values) {
        for (final corners in CoolIconCorners.values) {
          final svg = entry.value.svgFor(style, corners);
          expect(svg, startsWith('<svg'));
          expect(svg, contains('</svg>'));
        }
      }
    }
  });
}
