import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix.dart';
import '../../data/repository/grand_prix/grand_prix_repository_method_providers.dart';
import '../config/router/app_router.dart';
import '../provider/grand_prix_bet_points_provider.dart';
import 'grand_prix_item_component.dart';
import 'scroll_animated_item_component.dart';
import 'text_component.dart';

class SliverGrandPrixesList extends SliverPadding {
  SliverGrandPrixesList({super.key, required String playerId})
      : super(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 64),
          sliver: Consumer(
            builder: (
              BuildContext context,
              WidgetRef ref,
              __,
            ) =>
                ref.watch(allGrandPrixesProvider).when(
                      data: (List<GrandPrix>? grandPrixes) {
                        final sortedGrandPrixes = [...?grandPrixes];
                        sortedGrandPrixes.sort(
                          (gp1, gp2) => gp1.startDate.compareTo(gp2.startDate),
                        );

                        return _GrandPrixesList(
                          grandPrixes: sortedGrandPrixes,
                          playerId: playerId,
                        );
                      },
                      error: (_, __) => const SliverToBoxAdapter(
                        child: Center(
                          child: TitleMedium(
                            'Cannot load grand prixes',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      loading: () => const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
          ),
        );
}

class _GrandPrixesList extends SliverList {
  _GrandPrixesList({
    required List<GrandPrix> grandPrixes,
    required String playerId,
  }) : super(
          delegate: SliverChildBuilderDelegate(
            childCount: grandPrixes.length,
            (_, int index) {
              final grandPrix = grandPrixes[index];

              return ScrollAnimatedItem(
                child: Consumer(
                  builder: (context, ref, child) {
                    final grandPrixPoints = ref.watch(
                      grandPrixBetPointsProvider(
                        playerId: playerId,
                        grandPrixId: grandPrix.id,
                      ).select((state) => state.value?.totalPoints),
                    );

                    return GrandPrixItem(
                      betPoints: grandPrixPoints,
                      roundNumber: index + 1,
                      grandPrix: grandPrix,
                      onPressed: () {
                        context.navigateTo(
                          GrandPrixBetRoute(
                            grandPrixId: grandPrix.id,
                            playerId: playerId,
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        );
}
