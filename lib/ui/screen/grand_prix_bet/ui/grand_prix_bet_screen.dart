import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../extensions/build_context_extensions.dart';
import '../../../provider/grand_prix_id_provider.dart';
import '../../../service/dialog_service.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import '../notifier/grand_prix_bet_notifier_state.dart';
import 'grand_prix_bet_app_bar.dart';
import 'grand_prix_bet_body.dart';

@RoutePage()
class GrandPrixBetScreen extends StatelessWidget {
  final String? grandPrixId;

  const GrandPrixBetScreen({
    super.key,
    @PathParam('grandPrixId') this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    if (grandPrixId == null) {
      return const Text('Page not found');
    }

    return ProviderScope(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
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
