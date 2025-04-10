import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/theme/custom_colors.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../../../../extensions/widgets_list_extensions.dart';
import '../cubit/season_grand_prix_bet_editor_cubit.dart';
import 'season_grand_prix_bet_editor_driver_field.dart';

class SeasonGrandPrixBetEditorQuali extends StatelessWidget {
  const SeasonGrandPrixBetEditorQuali({super.key});

  void _onDriverSelected(
    int positionIndex,
    String selectedDriverId,
    BuildContext context,
  ) {
    context.read<SeasonGrandPrixBetEditorCubit>().onQualiStandingsChanged(
      standing: positionIndex + 1,
      driverId: selectedDriverId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String?> qualiStandingsBySeasonDriverIds = context.select(
      (SeasonGrandPrixBetEditorCubit cubit) =>
          cubit.state.qualiStandingsBySeasonDriverIds,
    );
    final CustomColors? customColors = context.customColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...List.generate(
          20,
          (int positionIndex) => SeasonGrandPrixBetEditorDriverField(
            label: 'P${positionIndex + 1}',
            labelColor: switch (positionIndex) {
              0 => customColors?.p1,
              1 => customColors?.p2,
              2 => customColors?.p3,
              _ => null,
            },
            selectedSeasonDriverId:
                qualiStandingsBySeasonDriverIds[positionIndex],
            allSelectedSeasonDriverIds:
                qualiStandingsBySeasonDriverIds.whereType<String>().toList(),
            onSeasonDriverSelected:
                (String selectedSeasonDriverId) => _onDriverSelected(
                  positionIndex,
                  selectedSeasonDriverId,
                  context,
                ),
          ),
        ).separated(const Divider()),
      ],
    );
  }
}
