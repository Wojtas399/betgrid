import 'package:flutter/widgets.dart';

extension WidgetsListExtensions on Iterable<Widget> {
  Iterable<Widget> separated(Widget separator) {
    final List<Widget> elementsToSeparate = toList();
    final List<Widget> separatedList = [];
    for (int itemIndex = 0; itemIndex < length; itemIndex++) {
      separatedList.add(elementsToSeparate[itemIndex]);
      if (itemIndex < length - 1) {
        separatedList.add(separator);
      }
    }
    return separatedList;
  }
}
