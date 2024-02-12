import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import '../../../component/driver_dropdown_button_component.dart';
import '../../../component/text/title.dart';

class GrandPrixBetPositionItem extends TableRow {
  const GrandPrixBetPositionItem({
    super.key,
    super.children,
  });

  factory GrandPrixBetPositionItem.build({
    required String label,
    required String? selectedDriverId,
    required List<Driver> allDrivers,
    required Function(String) onDriverSelected,
  }) {
    return GrandPrixBetPositionItem(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: TitleMedium(label),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: DriverDropdownButton(
              selectedDriverId: selectedDriverId,
              allDrivers: allDrivers,
              onDriverSelected: onDriverSelected,
            ),
          ),
        ),
      ],
    );
  }
}
