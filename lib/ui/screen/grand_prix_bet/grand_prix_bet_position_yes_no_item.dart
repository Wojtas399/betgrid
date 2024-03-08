import 'package:flutter/material.dart';

import '../../component/gap/gap_vertical.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetPositionYesNoItem extends TableRow {
  const GrandPrixBetPositionYesNoItem({super.key, super.children});

  factory GrandPrixBetPositionYesNoItem.build({
    required BuildContext context,
    required String label,
    bool? initialValue,
    int? points,
  }) {
    return GrandPrixBetPositionYesNoItem(
      children: [
        GrandPrixBetLabelCell.build(
          context: context,
          label: label,
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: _SelectedValue(selectedValue: initialValue),
          ),
        ),
        _BetPoints.build(
          context: context,
          points: points,
        ),
      ],
    );
  }
}

class _SelectedValue extends StatelessWidget {
  final bool? selectedValue;

  const _SelectedValue({required this.selectedValue});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TitleMedium(
        switch (selectedValue) {
          true => context.str.yes,
          false => context.str.no,
          null => '--',
        },
      ),
    );
  }
}

class _BetPoints extends TableCell {
  const _BetPoints({required super.child})
      : super(verticalAlignment: TableCellVerticalAlignment.middle);

  factory _BetPoints.build({
    required BuildContext context,
    int? points,
  }) =>
      _BetPoints(
        child: Column(
          children: [
            Text(
              'Punkty',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
            const GapVertical4(),
            TitleMedium(
              points?.toString() ?? '--',
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
      );
}
