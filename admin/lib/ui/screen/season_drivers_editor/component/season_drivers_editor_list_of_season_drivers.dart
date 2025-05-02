import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/widget_list_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_drivers_editor_cubit.dart';
import '../cubit/season_drivers_editor_state.dart';
import 'season_drivers_editor_driver_item.dart';

class SeasonDriversEditorListOfSeasonDrivers extends StatelessWidget {
  const SeasonDriversEditorListOfSeasonDrivers({super.key});

  Future<void> _onDeleteDriver(
    String seasonDriverId,
    String driverName,
    String driverSurname,
    BuildContext context,
  ) async {
    final cubit = context.read<SeasonDriversEditorCubit>();
    final bool? canDelete = await getIt<DialogService>().askForConfirmation(
      title:
          context.str.seasonDriversEditorSeasonDriverDeletionConfirmationTitle,
      message: context.str
          .seasonDriversEditorSeasonDriverDeletionConfirmationMessage(
            '$driverName $driverSurname',
            cubit.state.selectedSeason!,
          ),
    );
    if (canDelete == true) {
      cubit.deleteDriverFromSeason(seasonDriverId: seasonDriverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SeasonDriverDescription>? driversFromSeason = context.select(
      (SeasonDriversEditorCubit cubit) => cubit.state.driversInSeason,
    );

    return driversFromSeason != null
        ? Column(
          children: [
            ...driversFromSeason.map(
              (driverDescription) => SeasonDriversEditorDriverItem(
                driverDescription: driverDescription,
                onDelete:
                    () => _onDeleteDriver(
                      driverDescription.seasonDriverId,
                      driverDescription.name,
                      driverDescription.surname,
                      context,
                    ),
              ),
            ),
          ].divide(const Divider(height: 0)),
        )
        : const Center(child: CircularProgressIndicator());
  }
}
