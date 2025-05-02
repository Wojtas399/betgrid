import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/driver_personal_data.dart';
import '../cubit/new_season_driver_dialog_cubit.dart';

class NewSeasonDriverDialogDriverSelection extends StatelessWidget {
  const NewSeasonDriverDialogDriverSelection({super.key});

  void _onChanged(String? driverId, BuildContext context) {
    if (driverId != null) {
      context.read<NewSeasonDriverDialogCubit>().onDriverSelected(driverId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<DriverPersonalData>? driversToSelect = context.select(
      (NewSeasonDriverDialogCubit cubit) => cubit.state.driversToSelect,
    );
    final String? selectedDriverId = context.select(
      (NewSeasonDriverDialogCubit cubit) => cubit.state.selectedDriverId,
    );

    return DropdownButtonFormField<String>(
      value: selectedDriverId,
      items: [
        ...?driversToSelect?.map(
          (driver) => DropdownMenuItem<String>(
            value: driver.id,
            child: Text('${driver.name} ${driver.surname}'),
          ),
        ),
      ],
      onChanged: (String? driverId) => _onChanged(driverId, context),
    );
  }
}
