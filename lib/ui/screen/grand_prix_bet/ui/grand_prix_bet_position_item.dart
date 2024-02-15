import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../riverpod_provider/bet_mode_provider.dart';
import 'grand_prix_bet_driver_description.dart';
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
            child: _ValueCell(
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

class _ValueCell extends ConsumerWidget {
  final String? selectedDriverId;
  final List<Driver> allDrivers;
  final List<String> selectedDriverIds;
  final Function(String) onDriverSelected;

  const _ValueCell({
    required this.selectedDriverId,
    required this.allDrivers,
    this.selectedDriverIds = const [],
    required this.onDriverSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betMode = ref.watch(betModeProvider);

    return switch (betMode) {
      BetMode.edit => GrandPrixDriverDropdownButton(
          selectedDriverId: selectedDriverId,
          allDrivers: allDrivers,
          selectedDriverIds: selectedDriverIds,
          onDriverSelected: onDriverSelected,
        ),
      BetMode.preview => GrandPrixBetDriverDescription(
          driver: allDrivers.firstWhereOrNull(
            (driver) => driver.id == selectedDriverId,
          ),
        ),
    };
  }
}
