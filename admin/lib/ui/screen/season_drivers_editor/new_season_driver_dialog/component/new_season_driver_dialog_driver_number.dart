import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/new_season_driver_dialog_cubit.dart';

class NewSeasonDriverDialogDriverNumber extends StatelessWidget {
  const NewSeasonDriverDialogDriverNumber({super.key});

  void _onChanged(String? value, BuildContext context) {
    if (value == null) return;
    final int? driverNumber = int.tryParse(value);
    if (driverNumber != null) {
      context.read<NewSeasonDriverDialogCubit>().onDriverNumberChanged(
        driverNumber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(border: UnderlineInputBorder()),
      keyboardType: TextInputType.number,
      onChanged: (String? value) => _onChanged(value, context),
    );
  }
}
