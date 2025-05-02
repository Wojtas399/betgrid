import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_grand_prixes_editor_cubit.dart';
import '../cubit/season_grand_prixes_editor_state.dart';
import '../new_season_grand_prix_dialog/new_season_grand_prix_dialog.dart';
import 'season_grand_prixes_editor_list_of_season_grand_prixes.dart';
import 'season_grand_prixes_editor_season_selection.dart';

class SeasonGrandPrixesEditorContent extends StatelessWidget {
  const SeasonGrandPrixesEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _addGrandPrixToSeason(BuildContext context) async {
    final int? selectedSeason =
        context.read<SeasonGrandPrixesEditorCubit>().state.selectedSeason;
    if (selectedSeason == null) return;
    getIt<DialogService>().showFullScreenDialog(
      NewSeasonGrandPrixDialog(season: selectedSeason),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool? areThereOtherGrandPrixesToAdd = context.select(
      (SeasonGrandPrixesEditorCubit cubit) =>
          cubit.state.areThereOtherGrandPrixesToAdd,
    );

    return AppBar(
      title: Text(context.str.seasonGrandPrixesEditorScreenTitle),
      actions: [
        IconButton(
          onPressed:
              areThereOtherGrandPrixesToAdd == true
                  ? () => _addGrandPrixToSeason(context)
                  : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final cubitStatus = context.select(
      (SeasonGrandPrixesEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const SeasonGrandPrixesEditorSeasonSelection(),
                const GapVertical24(),
                if (cubitStatus.isChangingSeason) ...[
                  const CircularProgressIndicator(),
                ] else ...[
                  const SeasonGrandPrixesEditorListOfSeasonGrandPrixes(),
                  const GapVertical32(),
                ],
              ],
            ),
          ),
        );
  }
}
