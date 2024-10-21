import 'package:flutter/material.dart';

import '../../../component/text_component.dart';

class GrandPrixBetLabelCell extends TableCell {
  GrandPrixBetLabelCell({
    super.key,
    required String label,
    Color? labelColor,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.all(8),
            height: 80,
            child: Center(
              child: Builder(
                builder: (BuildContext context) => TitleMedium(
                  label,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                  color: labelColor,
                ),
              ),
            ),
          ),
        );
}
