import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../model/grand_prix_basic_info.dart';
import '../../../../extensions/build_context_extensions.dart';
import '../cubit/new_season_grand_prix_dialog_cubit.dart';

class NewSeasonGrandPrixDialogGrandPrixSelection extends StatelessWidget {
  const NewSeasonGrandPrixDialogGrandPrixSelection({super.key});

  void _onChanged(String? grandPrixId, BuildContext context) {
    if (grandPrixId != null) {
      context.read<NewSeasonGrandPrixDialogCubit>().onGrandPrixSelected(
        grandPrixId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Iterable<GrandPrixBasicInfo>? grandPrixesToSelect = context.select(
      (NewSeasonGrandPrixDialogCubit cubit) => cubit.state.grandPrixesToSelect,
    );
    final String? selectedGrandPrixId = context.select(
      (NewSeasonGrandPrixDialogCubit cubit) => cubit.state.selectedGrandPrixId,
    );

    return DropdownButtonFormField<String>(
      value: selectedGrandPrixId,
      decoration: InputDecoration(
        hintText: context.str.seasonGrandPrixesEditorSelectGrandPrix,
      ),
      items:
          grandPrixesToSelect
              ?.map(
                (GrandPrixBasicInfo grandPrix) => DropdownMenuItem<String>(
                  value: grandPrix.id,
                  child: Text(grandPrix.name),
                ),
              )
              .toList(),
      onChanged: (String? grandPrixId) => _onChanged(grandPrixId, context),
    );
  }
}
