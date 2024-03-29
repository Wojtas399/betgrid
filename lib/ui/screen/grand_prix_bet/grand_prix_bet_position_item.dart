import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../model/driver.dart';
import '../../component/gap/gap_horizontal.dart';
import '../../component/text/body.dart';
import '../../component/text/title.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetPositionItem extends TableRow {
  const GrandPrixBetPositionItem({super.key, super.children});

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
        _DriverDescription.build(
          driver: allDrivers.firstWhereOrNull(
            (driver) => driver.id == selectedDriverId,
          ),
        ),
      ],
    );
  }
}

class _DriverDescription extends TableCell {
  const _DriverDescription({required super.child})
      : super(verticalAlignment: TableCellVerticalAlignment.middle);

  factory _DriverDescription.build({Driver? driver}) => _DriverDescription(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: driver != null
              ? Row(
                  children: [
                    Container(
                      width: 8,
                      height: 20,
                      color: Color(driver.team.hexColor),
                    ),
                    const GapHorizontal4(),
                    SizedBox(
                      width: 25,
                      child: BodyMedium(
                        '${driver.number}',
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const GapHorizontal8(),
                    TitleMedium('${driver.name} ${driver.surname}'),
                  ],
                )
              : const Center(
                  child: TitleMedium(
                    '--',
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      );
}
