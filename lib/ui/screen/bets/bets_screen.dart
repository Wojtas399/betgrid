import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../../model/user.dart';
import '../../component/grand_prix_item_component.dart';
import '../../component/scroll_animated_item_component.dart';
import '../../config/router/app_router.dart';
import '../../provider/all_grand_prixes_provider.dart';
import '../../provider/grand_prix_bet_points_provider.dart';
import '../../provider/logged_user_data_notifier_provider.dart';

@RoutePage()
class BetsScreen extends StatelessWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: _GrandPrixes(),
        ),
      ],
    );
  }
}

class _GrandPrixes extends ConsumerWidget {
  const _GrandPrixes();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<GrandPrix>?> allGrandPrixesAsyncVal = ref.watch(
      allGrandPrixesProvider,
    );
    final String? loggedUserId = ref.watch(
      loggedUserDataNotifierProvider.select(
        (AsyncValue<User?> user) => user.value?.id,
      ),
    );

    final List<GrandPrix>? allGrandPrixes = allGrandPrixesAsyncVal.value;
    if (allGrandPrixes?.isNotEmpty == true && loggedUserId != null) {
      return ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: allGrandPrixes!.length,
        itemBuilder: (_, int itemIndex) {
          final grandPrix = allGrandPrixes[itemIndex];

          return ScrollAnimatedItem(
            child: GrandPrixItem(
              betPoints: ref.watch(
                grandPrixBetPointsProvider(
                  grandPrixId: grandPrix.id,
                  playerId: loggedUserId,
                ),
              ),
              roundNumber: itemIndex + 1,
              grandPrix: grandPrix,
              onPressed: () {
                context.navigateTo(
                  GrandPrixBetRoute(
                    grandPrixId: grandPrix.id,
                    playerId: loggedUserId,
                  ),
                );
              },
            ),
          );
        },
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
