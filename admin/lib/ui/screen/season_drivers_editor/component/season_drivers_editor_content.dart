import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../service/dialog_service.dart';
import '../cubit/season_drivers_editor_cubit.dart';
import '../cubit/season_drivers_editor_state.dart';
import '../new_season_driver_dialog/new_season_driver_dialog.dart';
import 'season_drivers_editor_list_of_season_drivers.dart';
import 'season_drivers_editor_season_selection.dart';

class SeasonDriversEditorContent extends StatelessWidget {
  const SeasonDriversEditorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(appBar: _AppBar(), body: _Body());
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  Future<void> _addTeamToSeason(BuildContext context) async {
    final int? selectedSeason =
        context.read<SeasonDriversEditorCubit>().state.selectedSeason;
    if (selectedSeason == null) return;
    getIt<DialogService>().showFullScreenDialog(
      NewSeasonDriverDialog(season: selectedSeason),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool? areThereOtherDriversToAdd = context.select(
      (SeasonDriversEditorCubit cubit) => cubit.state.areThereOtherDriversToAdd,
    );

    return AppBar(
      title: Text(context.str.seasonDriversEditorScreenTitle),
      actions: [
        IconButton(
          onPressed:
              areThereOtherDriversToAdd == true
                  ? () => _addTeamToSeason(context)
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
      (SeasonDriversEditorCubit cubit) => cubit.state.status,
    );

    return cubitStatus.isInitial
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                const SeasonDriversEditorSeasonSelection(),
                const GapVertical24(),
                if (cubitStatus.isChangingSeason)
                  const CircularProgressIndicator()
                else
                  const SeasonDriversEditorListOfSeasonDrivers(),
                const GapVertical32(),
              ],
            ),
          ),
        );
  }
}
