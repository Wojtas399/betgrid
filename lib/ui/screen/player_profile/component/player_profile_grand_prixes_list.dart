import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../component/grand_prix_item_component.dart';
import '../../../component/scroll_animated_item_component.dart';
import '../../../config/router/app_router.dart';
import '../cubit/player_profile_cubit.dart';
import '../cubit/player_profile_state.dart';

class PlayerProfileGrandPrixesList extends StatelessWidget {
  const PlayerProfileGrandPrixesList({super.key});

  void _onGrandPrixPressed(String grandPrixId, BuildContext context) {
    final PlayerProfileCubit cubit = context.read<PlayerProfileCubit>();
    final String? playerId = cubit.state.player?.id;
    final int? season = cubit.state.season;

    if (playerId != null && season != null) {
      context.navigateTo(
        SeasonGrandPrixBetPreviewRoute(
          playerId: playerId,
          season: season,
          seasonGrandPrixId: grandPrixId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isCubitLoading = context.select(
      (PlayerProfileCubit cubit) => cubit.state.status.isLoading,
    );
    final List<GrandPrixWithPoints> grandPrixesWithPoints = context.select(
      (PlayerProfileCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 64),
      sliver:
          isCubitLoading
              ? const SliverFillRemaining(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [CircularProgressIndicator()],
                ),
              )
              : SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: grandPrixesWithPoints.length,
                  (BuildContext context, int index) {
                    final item = grandPrixesWithPoints[index];

                    return ScrollAnimatedItem(
                      child: GrandPrixItem(
                        betPoints: item.points,
                        name: item.name,
                        countryAlpha2Code: item.countryAlpha2Code,
                        roundNumber: item.roundNumber,
                        startDate: item.startDate,
                        endDate: item.endDate,
                        onPressed:
                            () => _onGrandPrixPressed(
                              item.seasonGrandPrixId,
                              context,
                            ),
                      ),
                    );
                  },
                ),
              ),
    );
  }
}
