import 'package:flutter/widgets.dart';

extension WidgetListExtensions on List<Widget> {
  List<Widget> divide(Widget divider) {
    final List<Widget> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(divider);
      }
    }
    return result;
  }
}
