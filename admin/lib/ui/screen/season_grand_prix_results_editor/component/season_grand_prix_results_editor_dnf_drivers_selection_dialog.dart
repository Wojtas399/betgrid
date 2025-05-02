import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/padding_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/string_extensions.dart';
import '../../../extensions/widget_list_extensions.dart';
import '../cubit/season_grand_prix_results_editor_cubit.dart';
import '../cubit/season_grand_prix_results_editor_state.dart';
import 'season_grand_prix_results_editor_driver_description.dart';

class SeasonGrandPrixResultsEditorDnfDriversSelectionDialog
    extends StatelessWidget {
  const SeasonGrandPrixResultsEditorDnfDriversSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<DriverDetails>? allDrivers = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .allSeasonDrivers,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.seasonGrandPrixResultsEditorDnf),
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        surfaceTintColor: context.colorScheme.surfaceContainerHighest,
      ),
      body: SafeArea(
        child:
            allDrivers != null
                ? Column(
                  children: [
                    Container(
                      color: context.colorScheme.surfaceContainerHighest,
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: const _SelectedDrivers(),
                    ),
                    Expanded(
                      child: _ListOfDriversToSelect(drivers: allDrivers),
                    ),
                  ],
                )
                : const _NoDriversInfo(),
      ),
    );
  }
}

class _SelectedDrivers extends StatelessWidget {
  const _SelectedDrivers();

  @override
  Widget build(BuildContext context) {
    final List<DriverDetails>? dnfDrivers = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .dnfSeasonDrivers,
    );

    return Column(
      children: [
        if (dnfDrivers?.isNotEmpty == true) const GapVertical16(),
        ...?dnfDrivers
            ?.map(
              (DriverDetails driver) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SeasonGrandPrixResultsEditorDriverDescription(
                    name: driver.name,
                    surname: driver.surname,
                    number: driver.number,
                    teamColor: driver.teamHexColor.toColor(),
                  ),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      onPressed:
                          () => context
                              .read<SeasonGrandPrixResultsEditorCubit>()
                              .onDnfDriverRemoved(driver.seasonDriverId),
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            )
            .toList()
            .divide(const GapVertical8()),
      ],
    );
  }
}

class _ListOfDriversToSelect extends StatelessWidget {
  final List<DriverDetails> drivers;

  const _ListOfDriversToSelect({required this.drivers});

  @override
  Widget build(BuildContext context) {
    final List<DriverDetails>? dnfDrivers = context.select(
      (SeasonGrandPrixResultsEditorCubit cubit) =>
          (cubit.state as SeasonGrandPrixResultsEditorStateLoaded)
              .raceForm
              .dnfSeasonDrivers,
    );

    return SingleChildScrollView(
      child: Padding24(
        child: Column(
          children: [
            ...drivers
                .where(
                  (DriverDetails driver) =>
                      dnfDrivers?.contains(driver) == false,
                )
                .map(
                  (DriverDetails driver) => _DriverItem(
                    driver: driver,
                    onTap:
                        () => context
                            .read<SeasonGrandPrixResultsEditorCubit>()
                            .onDnfDriverSelected(driver.seasonDriverId),
                  ),
                )
                .toList()
                .divide(const SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}

class _DriverItem extends StatelessWidget {
  final DriverDetails driver;
  final VoidCallback onTap;

  const _DriverItem({required this.driver, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: SeasonGrandPrixResultsEditorDriverDescription(
        name: driver.name,
        surname: driver.surname,
        number: driver.number,
        teamColor: driver.teamHexColor.toColor(),
      ),
    ),
  );
}

class _NoDriversInfo extends StatelessWidget {
  const _NoDriversInfo();

  @override
  Widget build(BuildContext context) => EmptyContentInfo(
    title: context.str.seasonGrandPrixResultsEditorNoDriversInfoTitle,
    message: context.str.seasonGrandPrixResultsEditorNoDriversInfoSubtitle,
  );
}
