import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../dependency_injection.dart';
import '../../component/sliver_grand_prixes_list_component.dart';
import '../../component/sliver_player_total_points_component.dart';
import '../../config/router/app_router.dart';
import '../../provider/grand_prixes_with_points_provider.dart';
import '../../provider/player_points_provider.dart';

@RoutePage()
class BetsScreen extends StatelessWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loggedUserId$ = getIt.get<AuthRepository>().loggedUserId$;

    return StreamBuilder(
      stream: loggedUserId$,
      builder: (_, AsyncSnapshot<String?> asyncSnapshot) =>
          asyncSnapshot.connectionState == ConnectionState.waiting
              ? const CircularProgressIndicator()
              : CustomScrollView(
                  slivers: [
                    _TotalPoints(loggedUserId: asyncSnapshot.data!),
                    _GrandPrixes(loggedUserId: asyncSnapshot.data!),
                  ],
                ),
    );
  }
}

class _TotalPoints extends ConsumerWidget {
  final String loggedUserId;

  const _TotalPoints({required this.loggedUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalPointsAsyncVal =
        ref.watch(playerPointsProvider(playerId: loggedUserId));

    return SliverPlayerTotalPoints(
      points: totalPointsAsyncVal.value,
      isLoading: totalPointsAsyncVal.isLoading,
    );
  }
}

class _GrandPrixes extends ConsumerWidget {
  final String loggedUserId;

  const _GrandPrixes({required this.loggedUserId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grandPrixesWithPointsAsyncVal = ref.watch(
      grandPrixesWithPointsProvider(playerId: loggedUserId),
    );

    return SliverGrandPrixesList(
      playerId: loggedUserId,
      grandPrixesWithPoints: [...?grandPrixesWithPointsAsyncVal.value],
      onGrandPrixPressed: (String grandPrixId) {
        context.navigateTo(
          GrandPrixBetRoute(
            grandPrixId: grandPrixId,
            playerId: loggedUserId,
          ),
        );
      },
      isLoading: grandPrixesWithPointsAsyncVal.isLoading,
    );
  }
}
