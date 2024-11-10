import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../../model/driver.dart';
import '../../../component/driver_description_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
import '../../../extensions/widgets_list_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';
import 'grand_prix_bet_editor_boolean_field.dart';
import 'grand_prix_bet_editor_dnf_drivers_selection_dialog.dart';
import 'grand_prix_bet_editor_driver_field.dart';
import 'grand_prix_bet_editor_race_podium_and_p10.dart';

class GrandPrixBetEditorRace extends StatelessWidget {
  const GrandPrixBetEditorRace({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: context.str.grandPrixBetEditorPodiumAndP10Title,
          subtitle: context.str.grandPrixBetEditorPodiumAndP10Subtitle,
        ),
        const GapVertical16(),
        const GrandPrixBetEditorRacePodiumAndP10(),
        const Divider(height: 32),
        _SectionHeader(
          title: context.str.fastestLap,
          subtitle: context.str.grandPrixBetEditorFastestLapSubtitle,
        ),
        const GapVertical16(),
        const _FastestLap(),
        const Divider(height: 32),
        _SectionHeader(
          title: context.str.grandPrixBetEditorDnfTitle,
          subtitle: context.str.grandPrixBetEditorDnfSubtitle,
        ),
        const GapVertical16(),
        const _DnfDrivers(),
        const Divider(height: 32),
        _SectionHeader(
          title: context.str.safetyCar,
          subtitle: context.str.grandPrixBetEditorSafetyCarSubtitle,
        ),
        const GapVertical16(),
        const _SafetyCar(),
        const Divider(height: 32),
        _SectionHeader(
          title: context.str.redFlag,
          subtitle: context.str.grandPrixBetEditorRedFlagSubtitle,
        ),
        const GapVertical16(),
        const _RedFlag(),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleMedium(
            title,
            fontWeight: FontWeight.bold,
          ),
          const GapVertical4(),
          BodyMedium(subtitle)
        ],
      ),
    );
  }
}

class _FastestLap extends StatelessWidget {
  const _FastestLap();

  @override
  Widget build(BuildContext context) {
    final String? fastestLapSeasonDriverId = context.select(
      (GrandPrixBetEditorCubit cubit) =>
          cubit.state.raceForm.fastestLapSeasonDriverId,
    );

    return GrandPrixBetEditorDriverField(
      selectedDriverId: fastestLapSeasonDriverId,
      onDriverSelected:
          context.read<GrandPrixBetEditorCubit>().onRaceFastestLapDriverChanged,
    );
  }
}

class _DnfDrivers extends StatelessWidget {
  const _DnfDrivers();

  Future<void> _onAddDriverPressed(BuildContext context) async {
    await getIt<DialogService>().showFullScreenDialog(
      BlocProvider.value(
        value: context.read<GrandPrixBetEditorCubit>(),
        child: const GrandPrixBetEditorDnfDriversSelectionDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Driver> dnfDrivers = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.dnfDrivers,
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (dnfDrivers.isNotEmpty) ...[
            ...dnfDrivers
                .map(
                  (Driver driver) => DriverDescription(
                    name: driver.name,
                    surname: driver.surname,
                    number: driver.number,
                    teamColor: driver.teamHexColor.toColor(),
                  ),
                )
                .separated(const GapVertical16()),
            const GapVertical16(),
          ],
          OutlinedButton(
            onPressed: () => _onAddDriverPressed(context),
            child: Text(
              dnfDrivers.isEmpty
                  ? context.str.grandPrixBetEditorAddDriversToDnfList
                  : context.str.grandPrixBetEditorEditDnfList,
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
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.willBeSafetyCar,
    );

    return GrandPrixBetEditorBooleanField(
      selectedValue: willBeSafetyCar,
      onValueSelected:
          context.read<GrandPrixBetEditorCubit>().onSafetyCarPredictionChanged,
    );
  }
}

class _RedFlag extends StatelessWidget {
  const _RedFlag();

  @override
  Widget build(BuildContext context) {
    final bool? willBeRedFlag = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.willBeRedFlag,
    );

    return GrandPrixBetEditorBooleanField(
      selectedValue: willBeRedFlag,
      onValueSelected:
          context.read<GrandPrixBetEditorCubit>().onRedFlagPredictionChanged,
    );
  }
}
