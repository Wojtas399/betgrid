import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../extensions/build_context_extensions.dart';
import '../cubit/player_profile_cubit.dart';
import '../cubit/player_profile_state.dart';
import 'player_profile_app_bar.dart';
import 'player_profile_grand_prixes_list.dart';
import 'player_profile_total_points.dart';

class PlayerProfileContent extends StatelessWidget {
  const PlayerProfileContent({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: _Body());
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.status.isLoading,
    );

    return isCubitLoading
        ? const Center(child: CircularProgressIndicator())
        : CustomScrollView(
          slivers: [
            PlayerProfileAppBar.build(
              backgroundColor: context.colorScheme.primary,
              foregroundColor: Theme.of(context).canvasColor,
            ),
            const PlayerProfileTotalPoints(),
            const PlayerProfileGrandPrixesList(),
          ],
        );
  }
}
