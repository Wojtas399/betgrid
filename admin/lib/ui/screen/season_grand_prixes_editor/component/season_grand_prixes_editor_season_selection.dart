import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/text_component.dart';
import '../../../extensions/build_context_extensions.dart';
import '../cubit/season_grand_prixes_editor_cubit.dart';

class SeasonGrandPrixesEditorSeasonSelection extends StatelessWidget {
  const SeasonGrandPrixesEditorSeasonSelection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [TitleMedium(context.str.season), const _DropdownButton()],
      ),
    );
  }
}

class _DropdownButton extends StatelessWidget {
  const _DropdownButton();

  void _onChanged(BuildContext context, int? season) {
    if (season != null) {
      context.read<SeasonGrandPrixesEditorCubit>().onSeasonSelected(season);
    }
  }

  @override
  Widget build(BuildContext context) {
    final int? currentSeason = context.select(
      (SeasonGrandPrixesEditorCubit cubit) => cubit.state.currentSeason,
    );
    final int? selectedSeason = context.select(
      (SeasonGrandPrixesEditorCubit cubit) => cubit.state.selectedSeason,
    );

    return currentSeason != null && selectedSeason != null
        ? DropdownButtonFormField(
          value: selectedSeason,
          items: [
            DropdownMenuItem(
              value: currentSeason,
              child: Text('$currentSeason'),
            ),
            DropdownMenuItem(
              value: currentSeason + 1,
              child: Text('${currentSeason + 1}'),
            ),
          ],
          onChanged: (int? value) => _onChanged(context, value),
        )
        : const CircularProgressIndicator();
  }
}
