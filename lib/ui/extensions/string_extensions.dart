import 'dart:ui';

extension StringExtensions on String {
  Color toColor() => Color(
        int.parse(substring(1, 7), radix: 16) + 0xFF000000,
      );
}
