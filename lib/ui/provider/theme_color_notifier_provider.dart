import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_color_notifier_provider.g.dart';

@riverpod
class ThemeColorNotifier extends _$ThemeColorNotifier {
  @override
  ThemeColor build() {
    return ThemeColor.defaultRed;
  }

  void changeThemeColor(ThemeColor color) {
    state = color;
  }
}

enum ThemeColor {
  defaultRed(Colors.red),
  pink(Colors.pink),
  purple(Colors.purple),
  orange(Colors.orange),
  yellow(Colors.yellow),
  green(Colors.green),
  teal(Colors.teal),
  blue(Colors.blue);

  final Color value;

  const ThemeColor(this.value);
}
