import 'package:flutter/material.dart';

import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widgets_list_extensions.dart';
import 'grand_prix_bet_editor_driver_field.dart';

class GrandPrixBetEditorQuali extends StatelessWidget {
  const GrandPrixBetEditorQuali({super.key});

  void _onDriverSelected(
    int positionIndex,
    String selectedDriverId,
    BuildContext context,
  ) {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    final CustomColors? customColors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          20,
          (int positionIndex) => GrandPrixBetEditorDriverField(
            label: 'P${positionIndex + 1}',
            labelColor: switch (positionIndex) {
              0 => customColors?.p1,
              1 => customColors?.p2,
              2 => customColors?.p3,
              _ => null,
            },
            onDriverSelected: (String selectedDriverId) => _onDriverSelected(
              positionIndex,
              selectedDriverId,
              context,
            ),
          ),
        ).separated(
          const Divider(),
        ),
      ],
    );
  }
}
