import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/season_team.dart';
import '../../../component/padding/padding_components.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
import '../cubit/season_team_details_cubit.dart';
import '../cubit/season_team_details_state.dart';

class SeasonTeamDetailsBody extends StatelessWidget {
  const SeasonTeamDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final SeasonTeamDetailsState state =
        context.watch<SeasonTeamDetailsCubit>().state;

    return switch (state) {
      SeasonTeamDetailsStateInitial() => const LinearProgressIndicator(),
      SeasonTeamDetailsStateLoaded() => const _LoadedState(),
      _ => const Placeholder(),
    };
  }
}

class _LoadedState extends StatelessWidget {
  const _LoadedState();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding16(
        child: Column(
          spacing: 24.0,
          children: [
            _CarImage(),
            _TeamFullName(),
            Divider(height: 0),
            _Drivers(),
            Divider(height: 0),
            _Details(),
          ],
        ),
      ),
    );
  }
}

class _CarImage extends StatelessWidget {
  const _CarImage();

  @override
  Widget build(BuildContext context) {
    final String? teamBaseHexColor = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team.baseHexColor,
    );
    final String? carImageUrl = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team.carImgUrl,
    );

    return carImageUrl == null
        ? const SizedBox.shrink()
        : Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: teamBaseHexColor?.toColor().withAlpha(100),
            border: Border.all(
              width: 2,
              color: teamBaseHexColor?.toColor() ?? context.colorScheme.surface,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Image.network(carImageUrl),
        );
  }
}

class _TeamFullName extends StatelessWidget {
  const _TeamFullName();

  @override
  Widget build(BuildContext context) {
    final String fullName = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team.fullName,
    );

    return TitleLarge(fullName);
  }
}

class _Details extends StatelessWidget {
  const _Details();

  @override
  Widget build(BuildContext context) {
    final SeasonTeam team = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          _buildLabeledText('Szef', team.teamChief),
          _buildLabeledText('Szef techniczny', team.technicalChief),
          _buildLabeledText('Model samochodu', team.chassis),
          _buildLabeledText('Silnik', team.powerUnit),
        ],
      ),
    );
  }

  Widget _buildLabeledText(String label, String value) {
    return Row(
      children: [
        Expanded(child: BodyMedium(label)),
        Expanded(
          child: BodyMedium(
            value,
            textAlign: TextAlign.end,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _Drivers extends StatelessWidget {
  const _Drivers();

  @override
  Widget build(BuildContext context) {
    final List<SeasonTeamDetailsDriverInfo> drivers = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.drivers,
    );

    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(child: _DriverInfo(drivers.first)),
          const VerticalDivider(),
          Expanded(child: _DriverInfo(drivers.last)),
        ],
      ),
    );
  }
}

class _DriverInfo extends StatelessWidget {
  final SeasonTeamDetailsDriverInfo driver;

  const _DriverInfo(this.driver);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleLarge('${driver.number}', fontWeight: FontWeight.bold),
        TitleMedium(
          '${driver.name} ${driver.surname}',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
