import 'package:flutter/widgets.dart';

extension WidgetsListExtensions on List<Widget> {
  List<Widget> separated(Widget separator) {
    final List<Widget> separatedList = [];
    for (int itemIndex = 0; itemIndex < length; itemIndex++) {
      separatedList.add(this[itemIndex]);
      if (itemIndex < length - 1) {
        separatedList.add(separator);
      }
    }
    return separatedList;
  }
}
