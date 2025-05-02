import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/theme/custom_colors.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widget_list_extensions.dart';
import '../cubit/season_grand_prix_results_editor_cubit.dart';
import '../cubit/season_grand_prix_results_editor_state.dart';
import 'season_grand_prix_results_editor_driver_field.dart';

class SeasonGrandPrixResultsEditorQuali extends StatelessWidget {
  const SeasonGrandPrixResultsEditorQuali({super.key});

  void _onDriverSelected(
    int positionIndex,
    String selectedDriverId,
    BuildContext context,
  ) {
    context.read<SeasonGrandPrixResultsEditorCubit>().onQualiStandingsChanged(
      standing: positionIndex + 1,
      driverId: selectedDriverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String?> qualiStandingsBySeasonDriverIds = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .qualiStandingsBySeasonDriverIds,
    );
    final CustomColors? customColors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          20,
          (int positionIndex) => SeasonGrandPrixResultsEditorDriverField(
            label: 'P${positionIndex + 1}',
            labelColor: switch (positionIndex) {
              0 => customColors?.p1,
              1 => customColors?.p2,
              2 => customColors?.p3,
              _ => null,
            },
            selectedDriverId: qualiStandingsBySeasonDriverIds[positionIndex],
            onDriverSelected:
                (String selectedDriverId) =>
                    _onDriverSelected(positionIndex, selectedDriverId, context),
          ),
        ).divide(const Divider()),
      ],
    );
  }
}
