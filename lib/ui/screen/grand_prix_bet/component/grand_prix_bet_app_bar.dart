import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/grand_prix_bet_cubit.dart';

class GrandPrixBetAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GrandPrixBetAppBar({super.key});

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
      (GrandPrixBetCubit cubit) => cubit.state.playerUsername,
    );
    final String? grandPrixName = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.grandPrixName,
    );
    final bool? isPlayerIdSameAsLoggedUserId = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.isPlayerIdSameAsLoggedUserId,
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
