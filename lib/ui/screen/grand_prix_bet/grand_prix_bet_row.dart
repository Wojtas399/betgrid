import 'package:flutter/material.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/label.dart';
import '../../component/text/title.dart';
import '../../extensions/build_context_extensions.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetRow extends TableRow {
  const GrandPrixBetRow({super.key, super.children});

  factory GrandPrixBetRow.build({
    required BuildContext context,
    required String label,
    Color? labelBackgroundColor,
    required Widget betChild,
    required Widget resultsChild,
    int? points,
  }) {
    return GrandPrixBetRow(
      children: [
        GrandPrixBetLabelCell.build(
          context: context,
          label: label,
          labelBackgroundColor: labelBackgroundColor,
        ),
        _BetInfo.build(
          context: context,
          betChild: betChild,
          resultsChild: resultsChild,
        ),
        _BetPoints.build(
          context: context,
          points: points,
        ),
      ],
    );
  }
}

class _BetInfo extends TableCell {
  const _BetInfo({required super.child})
      : super(verticalAlignment: TableCellVerticalAlignment.middle);

  factory _BetInfo.build({
    required BuildContext context,
    required Widget betChild,
    required Widget resultsChild,
  }) =>
      _BetInfo(
        child: Column(
          children: [
            const GapVertical8(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: LabelLarge('${context.str.grandPrixBetChoice}:'),
                  ),
                  const GapHorizontal8(),
                  betChild,
                ],
              ),
            ),
            const Divider(thickness: 0.25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    child: LabelLarge('${context.str.grandPrixBetResult}:'),
                  ),
                  const GapHorizontal8(),
                  resultsChild
                ],
              ),
            ),
            const GapVertical8(),
          ],
        ),
      );
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
            LabelLarge(
              context.str.grandPrixBetPoints,
              color: Theme.of(context).colorScheme.outline,
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
