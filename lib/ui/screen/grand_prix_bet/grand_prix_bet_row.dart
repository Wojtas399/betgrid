import 'package:flutter/material.dart';

import '../../component/gap/gap_horizontal.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text_component.dart';
import '../../extensions/build_context_extensions.dart';
import 'grand_prix_bet_label_cell.dart';

class GrandPrixBetRow extends TableRow {
  GrandPrixBetRow({
    super.key,
    required String label,
    Color? labelBackgroundColor,
    required Widget betChild,
    required Widget resultsChild,
    double? points,
  }) : super(
          children: [
            GrandPrixBetLabelCell(
              label: label,
              labelBackgroundColor: labelBackgroundColor,
            ),
            _BetInfo(
              betChild: betChild,
              resultsChild: resultsChild,
            ),
            _BetPoints(points: points),
          ],
        );
}

class _BetInfo extends TableCell {
  _BetInfo({
    required Widget betChild,
    required Widget resultsChild,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Builder(
            builder: (BuildContext context) => Column(
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
          ),
        );
}

class _BetPoints extends TableCell {
  _BetPoints({double? points})
      : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Column(
            children: [
              Builder(
                builder: (BuildContext context) => LabelLarge(
                  context.str.points,
                  color: context.colorScheme.outline,
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
