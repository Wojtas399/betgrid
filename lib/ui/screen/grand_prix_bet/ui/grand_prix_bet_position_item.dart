import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import 'grand_prix_bet_label_cell.dart';
import 'grand_prix_driver_dropdown_button.dart';

class GrandPrixBetPositionItem extends TableRow {
  const GrandPrixBetPositionItem({
    super.key,
    super.children,
  });

  factory GrandPrixBetPositionItem.build({
    required BuildContext context,
    required String label,
    Color? labelBackgroundColor,
    required String? selectedDriverId,
    required List<Driver> allDrivers,
    List<String> selectedDriverIds = const [],
    required Function(String) onDriverSelected,
  }) {
    return GrandPrixBetPositionItem(
      children: [
        GrandPrixBetLabelCell.build(
          context: context,
          label: label,
          labelBackgroundColor: labelBackgroundColor,
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: GrandPrixDriverDropdownButton(
              selectedDriverId: selectedDriverId,
              allDrivers: allDrivers,
              selectedDriverIds: selectedDriverIds,
              onDriverSelected: onDriverSelected,
            ),
          ),
        ),
      ],
    );
  }
}
