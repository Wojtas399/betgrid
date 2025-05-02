import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
import '../../../extensions/widget_list_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_grand_prix_results_editor_cubit.dart';
import '../cubit/season_grand_prix_results_editor_state.dart';
import 'season_grand_prix_results_editor_boolean_field.dart';
import 'season_grand_prix_results_editor_dnf_drivers_selection_dialog.dart';
import 'season_grand_prix_results_editor_driver_description.dart';
import 'season_grand_prix_results_editor_driver_field.dart';
import 'season_grand_prix_results_editor_podium_and_p10.dart';

class SeasonGrandPrixResultsEditorRace extends StatelessWidget {
  const SeasonGrandPrixResultsEditorRace({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleMedium(context.str.seasonGrandPrixResultsEditorPodiumAndP10),
        const GapVertical16(),
        const SeasonGrandPrixResultsEditorPodiumAndP10(),
        const Divider(height: 32),
        TitleMedium(context.str.seasonGrandPrixResultsEditorFastestLap),
        const GapVertical16(),
        const _FastestLap(),
        const Divider(height: 32),
        TitleMedium(context.str.seasonGrandPrixResultsEditorDnf),
        const GapVertical16(),
        const _DnfDrivers(),
        const Divider(height: 32),
        TitleMedium(context.str.seasonGrandPrixResultsEditorSafetyCar),
        const GapVertical16(),
        const _SafetyCar(),
        const Divider(height: 32),
        TitleMedium(context.str.seasonGrandPrixResultsEditorRedFlag),
        const GapVertical16(),
        const _RedFlag(),
      ],
    );
  }
}

class _FastestLap extends StatelessWidget {
  const _FastestLap();

  @override
  Widget build(BuildContext context) {
    final String? fastestLapSeasonDriverId = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .fastestLapSeasonDriverId,
    );

    return SeasonGrandPrixResultsEditorDriverField(
      selectedDriverId: fastestLapSeasonDriverId,
      onDriverSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onRaceFastestLapDriverChanged,
    );
  }
}

class _DnfDrivers extends StatelessWidget {
  const _DnfDrivers();

  Future<void> _onAddDriverPressed(BuildContext context) async {
    await getIt<DialogService>().showFullScreenDialog(
      BlocProvider.value(
        value: context.read<SeasonGrandPrixResultsEditorCubit>(),
        child: const SeasonGrandPrixResultsEditorDnfDriversSelectionDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<DriverDetails>? dnfSeasonDrivers = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .dnfSeasonDrivers,
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (dnfSeasonDrivers?.isNotEmpty == true) ...[
            ...dnfSeasonDrivers!
                .map(
                  (DriverDetails driverDetails) =>
                      SeasonGrandPrixResultsEditorDriverDescription(
                        name: driverDetails.name,
                        surname: driverDetails.surname,
                        number: driverDetails.number,
                        teamColor: driverDetails.teamHexColor.toColor(),
                      ),
                )
                .toList()
                .divide(const GapVertical16()),
            const GapVertical16(),
          ],
          OutlinedButton(
            onPressed: () => _onAddDriverPressed(context),
            child: Text(
              dnfSeasonDrivers?.isEmpty == true
                  ? context.str.seasonGrandPrixResultsEditorAddDriversToDnfList
                  : context.str.seasonGrandPrixResultsEditorEditDnfList,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyCar extends StatelessWidget {
  const _SafetyCar();

  @override
  Widget build(BuildContext context) {
    final bool? willBeSafetyCar = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .wasThereSafetyCar,
    );

    return SeasonGrandPrixResultsEditorBooleanField(
      selectedValue: willBeSafetyCar,
      onValueSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onSafetyCarPredictionChanged,
    );
  }
}

class _RedFlag extends StatelessWidget {
  const _RedFlag();

  @override
  Widget build(BuildContext context) {
    final bool? willBeRedFlag = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .wasThereRedFlag,
    );

    return SeasonGrandPrixResultsEditorBooleanField(
      selectedValue: willBeRedFlag,
      onValueSelected:
          context
              .read<SeasonGrandPrixResultsEditorCubit>()
              .onRedFlagPredictionChanged,
    );
  }
}
