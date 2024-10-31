import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../model/driver.dart';
import '../../../component/driver_description_component.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widgets_list_extensions.dart';
import '../cubit/grand_prix_bet_editor_cubit.dart';

class GrandPrixBetEditorDnfDriversSelectionDialog extends StatelessWidget {
  const GrandPrixBetEditorDnfDriversSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Driver>? allDrivers = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.allDrivers,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.str.grandPrixBetEditorDnfTitle),
        backgroundColor: context.colorScheme.surfaceContainerHighest,
        surfaceTintColor: context.colorScheme.surfaceContainerHighest,
      ),
      body: SafeArea(
        child: allDrivers != null
            ? Column(
                children: [
                  Container(
                    color: context.colorScheme.surfaceContainerHighest,
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      children: [
                        BodyMedium(
                          context.str.grandPrixBetEditorDnfSubtitle,
                          textAlign: TextAlign.center,
                        ),
                        const _SelectedDrivers(),
                      ],
                    ),
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
    final List<Driver> dnfDrivers = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.dnfDrivers,
    );

    return Column(
      children: [
        if (dnfDrivers.isNotEmpty) const GapVertical16(),
        ...dnfDrivers
            .map(
              (Driver driver) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DriverDescription(driver: driver),
                  SizedBox(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      onPressed: () => context
                          .read<GrandPrixBetEditorCubit>()
                          .onDnfDriverRemoved(driver.id),
                      iconSize: 16,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            )
            .separated(const GapVertical8()),
      ],
    );
  }
}

class _ListOfDriversToSelect extends StatelessWidget {
  final List<Driver> drivers;

  const _ListOfDriversToSelect({
    required this.drivers,
  });

  @override
  Widget build(BuildContext context) {
    final List<Driver> dnfDrivers = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.raceForm.dnfDrivers,
    );
    final bool canSelectNextDnfDriver = context.select(
      (GrandPrixBetEditorCubit cubit) => cubit.state.canSelectNextDnfDriver,
    );

    return Opacity(
      opacity: canSelectNextDnfDriver ? 1 : 0.75,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              ...drivers
                  .where((Driver driver) => !dnfDrivers.contains(driver))
                  .map(
                    (Driver driver) => _DriverItem(
                      driver: driver,
                      isDisabled: dnfDrivers.length == 3,
                      onTap: () => context
                          .read<GrandPrixBetEditorCubit>()
                          .onDnfDriverSelected(driver.id),
                    ),
                  )
                  .separated(const SizedBox(height: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

class _DriverItem extends StatelessWidget {
  final Driver driver;
  final bool isDisabled;
  final VoidCallback onTap;

  const _DriverItem({
    required this.driver,
    required this.isDisabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: isDisabled ? null : onTap,
        child: Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: DriverDescription(driver: driver),
        ),
      );
}

class _NoDriversInfo extends StatelessWidget {
  const _NoDriversInfo();

  @override
  Widget build(BuildContext context) => EmptyContentInfo(
        title: context.str.grandPrixBetEditorNoDriversInfoTitle,
        message: context.str.grandPrixBetEditorNoDriversInfoSubtitle,
      );
}
