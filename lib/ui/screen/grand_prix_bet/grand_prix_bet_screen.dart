import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix_bet/grand_prix_bet_notifier_provider.dart';
import '../../provider/grand_prix_bet/grand_prix_bet_notifier_state.dart';
import '../../provider/grand_prix_id_provider.dart';
import '../../provider/player_id_provider.dart';
import '../../service/dialog_service.dart';
import 'grand_prix_bet_app_bar.dart';
import 'grand_prix_bet_body.dart';

@RoutePage()
class GrandPrixBetScreen extends StatelessWidget {
  final String grandPrixId;
  final String playerId;

  const GrandPrixBetScreen({
    super.key,
    required this.grandPrixId,
    required this.playerId,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
        playerIdProvider.overrideWithValue(playerId),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content();

  void _manageNotifierStatus(
    GrandPrixBetNotifierStatus? status,
    BuildContext context,
  ) {
    switch (status) {
      case GrandPrixBetNotifierStatusSavingData():
        showLoadingDialog();
      case GrandPrixBetNotifierStatusDataSaved():
        closeLoadingDialog();
        showSnackbarMessage(context.str.grandPrixBetSuccessfullySavedBets);
      case GrandPrixBetNotifierStatusComplete():
      case null:
        break;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      grandPrixBetNotifierProvider.select((state) => state.value?.status),
      (previous, next) {
        _manageNotifierStatus(next, context);
      },
    );

    return const Scaffold(
      appBar: GrandPrixBetAppBar(),
      body: SafeArea(
        child: GrandPrixBetBody(),
      ),
    );
  }
}
