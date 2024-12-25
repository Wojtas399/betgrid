import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../component/grand_prix_item_component.dart';
import '../../../component/scroll_animated_item_component.dart';
import '../../../config/router/app_router.dart';
import '../cubit/bets_cubit.dart';

class BetsListOfBets extends StatelessWidget {
  const BetsListOfBets({super.key});

  void _onGrandPrixPressed(String grandPrixId, BuildContext context) {
    final String? loggedUserId = context.read<BetsCubit>().state.loggedUserId;
    if (loggedUserId != null) {
      context.navigateTo(
        GrandPrixBetRoute(
          grandPrixId: grandPrixId,
          playerId: loggedUserId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<GrandPrixWithPoints>? grandPrixesWithPoints = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixesWithPoints,
    );

    return grandPrixesWithPoints == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: grandPrixesWithPoints.length,
            itemBuilder: (_, int itemIndex) {
              final item = grandPrixesWithPoints[itemIndex];

              return ScrollAnimatedItem(
                child: GrandPrixItem(
                  betPoints: item.points,
                  grandPrix: item.grandPrix,
                  onPressed: () => _onGrandPrixPressed(
                    item.grandPrix.seasonGrandPrixId,
                    context,
                  ),
                ),
              );
            },
          );
  }
}
