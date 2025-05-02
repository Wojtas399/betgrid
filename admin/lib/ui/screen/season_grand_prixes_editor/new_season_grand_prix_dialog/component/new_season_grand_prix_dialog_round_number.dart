import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/new_season_grand_prix_dialog_cubit.dart';

class NewSeasonGrandPrixDialogRoundNumber extends StatefulWidget {
  const NewSeasonGrandPrixDialogRoundNumber({super.key});

  @override
  State<NewSeasonGrandPrixDialogRoundNumber> createState() => _State();
}

class _State extends State<NewSeasonGrandPrixDialogRoundNumber> {
  final FocusNode _focusNode = FocusNode();

  void _onChanged(String value) {
    final int? roundNumber = int.tryParse(value);
    if (roundNumber != null) {
      context.read<NewSeasonGrandPrixDialogCubit>().onRoundNumberChanged(
        roundNumber,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int? roundNumber = context.select(
      (NewSeasonGrandPrixDialogCubit cubit) => cubit.state.roundNumber,
    );

    return TextFormField(
      focusNode: _focusNode,
      initialValue: roundNumber?.toString(),
      keyboardType: TextInputType.number,
      onChanged: _onChanged,
      onTapOutside: (_) {
        _focusNode.unfocus();
      },
    );
  }
}
