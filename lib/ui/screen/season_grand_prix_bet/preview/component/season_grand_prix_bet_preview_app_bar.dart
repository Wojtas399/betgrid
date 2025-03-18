import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/season_grand_prix_bet_preview_cubit.dart';

class SeasonGrandPrixBetPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SeasonGrandPrixBetPreviewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) =>
      AppBar(title: const _GrandPrixName(), scrolledUnderElevation: 0.0);
}

class _GrandPrixName extends StatelessWidget {
  const _GrandPrixName();

  @override
  Widget build(BuildContext context) {
    final String? playerUsername = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.playerUsername,
    );
    final String? grandPrixName = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) => cubit.state.grandPrixName,
    );
    final bool? isPlayerIdSameAsLoggedUserId = context.select(
      (SeasonGrandPrixBetPreviewCubit cubit) =>
          cubit.state.isPlayerIdSameAsLoggedUserId,
    );

    String title = '--';
    if (grandPrixName != null && playerUsername != null) {
      title = grandPrixName;
      if (isPlayerIdSameAsLoggedUserId == false) {
        title += ' ($playerUsername)';
      }
    }
    return Text(title);
  }
}
