import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/router/app_router.dart';
import '../cubit/grand_prix_bet_cubit.dart';

class GrandPrixBetAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GrandPrixBetAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: const _GrandPrixName(),
        scrolledUnderElevation: 0.0,
        actions: [
          const _EditButton(),
        ],
      );
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

class _EditButton extends StatelessWidget {
  const _EditButton();

  void _onPressed(BuildContext context) {
    final String? seasonGrandPrixId =
        context.read<GrandPrixBetCubit>().state.seasonGrandPrixId;
    if (seasonGrandPrixId != null) {
      context.pushRoute(
        GrandPrixBetEditorRoute(
          seasonGrandPrixId: seasonGrandPrixId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool? canEdit = context.select(
      (GrandPrixBetCubit cubit) => cubit.state.canEdit,
    );

    return IconButton(
      onPressed: canEdit == true ? () => _onPressed(context) : null,
      padding: const EdgeInsets.all(16),
      icon: const Icon(Icons.edit),
    );
  }
}
