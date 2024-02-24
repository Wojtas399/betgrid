import 'package:flutter/material.dart';

import '../../../component/text/title.dart';

class GrandPrixBetLabelCell extends TableCell {
  const GrandPrixBetLabelCell({super.key, required super.child})
      : super(verticalAlignment: TableCellVerticalAlignment.middle);

  factory GrandPrixBetLabelCell.build({
    required BuildContext context,
    required String label,
    Color? labelBackgroundColor,
  }) {
    return GrandPrixBetLabelCell(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: labelBackgroundColor,
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
    );
  }
}
