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
      ),
      body: SafeArea(
        child: allDrivers != null
            ? _ListOfDriversToSelect(drivers: allDrivers)
            : const _NoDriversInfo(),
      ),
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

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            BodyMedium(
              context.str.grandPrixBetEditorDnfSubtitle,
              textAlign: TextAlign.center,
            ),
            const GapVertical24(),
            ...drivers
                .map(
                  (Driver driver) => _DriverItem(
                    driver: driver,
                    isSelected: dnfDrivers.contains(driver),
                    onTap: () => context
                        .read<GrandPrixBetEditorCubit>()
                        .onDnfDriverSelected(driver.id),
                  ),
                )
                .toList()
                .separated(
                  const SizedBox(height: 16),
                ),
          ],
        ),
      ),
    );
  }
}

class _DriverItem extends StatelessWidget {
  final Driver driver;
  final bool isSelected;
  final VoidCallback onTap;

  const _DriverItem({
    required this.driver,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? context.colorScheme.surfaceContainerHighest
                : context.colorScheme.surfaceContainer,
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
