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
      child: SingleChildScrollView(
        child: Padding16(
          child: Column(
            children: [
              _Logo(),
              SizedBox(height: 16),
              _Drivers(),
              _CarImage(),
              SizedBox(height: 24),
              _Details(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final String? teamBaseHexColor = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team.baseHexColor,
    );
    final String? logoUrl = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team.logoImgUrl,
    );

    return logoUrl == null
        ? const SizedBox.shrink()
        : Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: teamBaseHexColor?.toColor().withAlpha(100),
            border: Border.all(
              width: 2,
              color: teamBaseHexColor?.toColor() ?? context.colorScheme.surface,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Image.network(logoUrl),
        );
  }
}

class _Drivers extends StatelessWidget {
  const _Drivers();

  @override
  Widget build(BuildContext context) {
    final List<SeasonTeamDetailsDriverInfo> drivers = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.mainDrivers,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(child: _DriverInfo(drivers.first)),
            const VerticalDivider(),
            Expanded(child: _DriverInfo(drivers.last)),
          ],
        ),
      ),
    );
  }
}

class _DriverInfo extends StatelessWidget {
  final SeasonTeamDetailsDriverInfo driver;

  const _DriverInfo(this.driver);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          TitleLarge('${driver.number}', fontWeight: FontWeight.bold),
          TitleMedium(
            '${driver.name} ${driver.surname}',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CarImage extends StatelessWidget {
  const _CarImage();

  @override
  Widget build(BuildContext context) {
    final String? carImageUrl = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team.carImgUrl,
    );

    return carImageUrl == null
        ? const SizedBox.shrink()
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Image.network(carImageUrl),
        );
  }
}

class _Details extends StatelessWidget {
  const _Details();

  @override
  Widget build(BuildContext context) {
    final SeasonTeam team = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.loaded.team,
    );
    final List<SeasonTeamDetailsDriverInfo> reserveDrivers = context.select(
      (SeasonTeamDetailsCubit cubit) => cubit.state.reserveDrivers,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        _buildLabeledText(context.str.seasonTeamDetailsName, team.fullName),
        const Divider(height: 8),
        _buildLabeledText(
          context.str.seasonTeamDetailsTeamChief,
          team.teamChief,
        ),
        const Divider(height: 8),
        _buildLabeledText(
          context.str.seasonTeamDetailsTechnicalChief,
          team.technicalChief,
        ),
        const Divider(height: 8),
        _buildLabeledText(context.str.seasonTeamDetailsChassis, team.chassis),
        const Divider(height: 8),
        _buildLabeledText(
          context.str.seasonTeamDetailsPowerUnit,
          team.powerUnit,
        ),
        const Divider(height: 8),
        _buildLabeledText(
          context.str.seasonTeamDetailsReserveDrivers,
          reserveDrivers.isNotEmpty
              ? reserveDrivers
                  .map((driver) => '${driver.name} ${driver.surname}')
                  .join('\n')
              : '- - -',
        ),
      ],
    );
  }

  Widget _buildLabeledText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        spacing: 8,
        children: [
          Expanded(flex: 1, child: BodyMedium(label)),
          Expanded(
            flex: 2,
            child: BodyMedium(
              value,
              textAlign: TextAlign.end,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
