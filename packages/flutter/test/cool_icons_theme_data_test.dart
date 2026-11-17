import 'package:coolicons_flutter/coolicons_flutter.dart';
// ignore: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CoolIconsThemeData', () {
    test('uses documented defaults', () {
      const theme = CoolIconsThemeData();

      expect(theme.style, CoolIconStyle.line);
      expect(theme.corners, CoolIconCorners.round);
      expect(theme.size, 24);
      expect(theme.color, isNull);
      expect(theme.strokeWidth, 2);
      expect(theme.secondaryColor, isNull);
      expect(theme.secondaryOpacity, isNull);
    });

    test('copyWith changes only requested values', () {
      const theme = CoolIconsThemeData(
        style: CoolIconStyle.line,
        corners: CoolIconCorners.round,
        size: 24,
      );

      final updated = theme.copyWith(
        style: CoolIconStyle.fill,
        size: 32,
        color: Colors.red,
      );

      expect(updated.style, CoolIconStyle.fill);
      expect(updated.corners, CoolIconCorners.round);
      expect(updated.size, 32);
      expect(updated.color, Colors.red);
    });

    test('copyWith can clear nullable values', () {
      const theme = CoolIconsThemeData(color: Colors.red);

      expect(theme.copyWith(clearColor: true).color, isNull);
    });

    test('lerp interpolates dimensions and colors', () {
      const a = CoolIconsThemeData(size: 20, color: Colors.black);
      const b = CoolIconsThemeData(size: 28, color: Colors.white);

      final middle = a.lerp(b, 0.5);

      expect(middle.size, 24);
      expect(middle.color, Color.lerp(Colors.black, Colors.white, 0.5));
    });
  });
}
