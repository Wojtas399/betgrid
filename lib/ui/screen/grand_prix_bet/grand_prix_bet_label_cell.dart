import 'package:flutter/material.dart';

import '../../component/text_component.dart';
import '../../extensions/build_context_extensions.dart';

class GrandPrixBetLabelCell extends TableCell {
  GrandPrixBetLabelCell({
    super.key,
    required String label,
    Color? labelBackgroundColor,
  }) : super(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: labelBackgroundColor,
            ),
            height: 80,
            child: Center(
              child: Builder(
                builder: (BuildContext context) => TitleMedium(
                  label,
                  color: labelBackgroundColor != null
                      ? Colors.white
                      : context.colorScheme.inverseSurface,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
}
