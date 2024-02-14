import 'package:flutter/material.dart';

import '../../../../model/driver.dart';
import '../../../component/text/title.dart';
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
    required Function(String) onDriverSelected,
  }) {
    return GrandPrixBetPositionItem(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: labelBackgroundColor,
              ),
              child: Center(
                child: TitleMedium(
                  label,
                  color: labelBackgroundColor != null
                      ? Colors.white
                      : Theme.of(context).colorScheme.inverseSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: GrandPrixDriverDropdownButton(
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
