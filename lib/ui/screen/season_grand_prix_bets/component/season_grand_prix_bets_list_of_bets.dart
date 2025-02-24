import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../component/grand_prix_item_component.dart';
import '../../../component/scroll_animated_item_component.dart';
import '../../../component/text_component.dart';
import '../../../config/router/app_router.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../extensions/duration_extensions.dart';
import '../cubit/season_grand_prix_bets_cubit.dart';
import '../cubit/season_grand_prix_bets_state.dart';

class SeasonGrandPrixBetsListOfBets extends StatelessWidget {
  const SeasonGrandPrixBetsListOfBets({super.key});

  void _onGrandPrixPressed(String seasonGrandPrixId, BuildContext context) {
    final SeasonGrandPrixBetsCubit cubit =
        context.read<SeasonGrandPrixBetsCubit>();
    final int? season = cubit.state.season;
    if (season != null) {
      context.navigateTo(
        SeasonGrandPrixBetRoute(
          season: season,
          seasonGrandPrixId: seasonGrandPrixId,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<SeasonGrandPrixItemParams>? seasonGrandPrixItems = context
        .select((SeasonGrandPrixBetsCubit cubit) => cubit.state.grandPrixItems);
    final bool doesOngoingGpExist = context.select(
      (SeasonGrandPrixBetsCubit cubit) => cubit.state.doesOngoingGpExist,
    );

    return seasonGrandPrixItems == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: seasonGrandPrixItems.length,
          itemBuilder: (_, int itemIndex) {
            final seasonGpParams = seasonGrandPrixItems[itemIndex];

            return ScrollAnimatedItem(
              child: _Item(
                gpParams: seasonGpParams,
                doesOngoingGpExist: doesOngoingGpExist,
                onPressed:
                    () => _onGrandPrixPressed(
                      seasonGpParams.seasonGrandPrixId,
                      context,
                    ),
              ),
            );
          },
        );
  }
}

class _Item extends StatelessWidget {
  final SeasonGrandPrixItemParams gpParams;
  final VoidCallback onPressed;
  final bool doesOngoingGpExist;

  const _Item({
    required this.gpParams,
    required this.onPressed,
    required this.doesOngoingGpExist,
  });

  @override
  Widget build(BuildContext context) {
    final gpStatus = gpParams.status;
    bool isMarked = false;
    if (doesOngoingGpExist) {
      isMarked = gpStatus.isOngoing;
    } else {
      isMarked = gpStatus.isNext;
    }

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: isMarked ? const EdgeInsets.all(8) : null,
          margin:
              isMarked
                  ? const EdgeInsets.only(top: 8, left: 4, right: 4, bottom: 8)
                  : null,
          decoration:
              isMarked
                  ? BoxDecoration(
                    border: Border.all(
                      color: context.colorScheme.primary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  )
                  : null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isMarked && gpStatus.isNext) const _EndBettingTime(),
              GrandPrixItem(
                name: gpParams.grandPrixName,
                countryAlpha2Code: gpParams.countryAlpha2Code,
                roundNumber: gpParams.roundNumber,
                startDate: gpParams.startDate,
                endDate: gpParams.endDate,
                betPoints: gpParams.betPoints,
                onPressed: onPressed,
              ),
            ],
          ),
        ),
        if (isMarked)
          Positioned(
            left: 24,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: context.colorScheme.surface,
              child: TitleMedium(
                gpStatus.isOngoing
                    ? context.str.betsOngoingStatus
                    : context.str.betsNextStatus,
                color: context.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _EndBettingTime extends StatelessWidget {
  const _EndBettingTime();

  @override
  Widget build(BuildContext context) {
    final Duration? durationToEnd = context.select(
      (SeasonGrandPrixBetsCubit cubit) => cubit.state.durationToStartNextGp,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          BodyMedium('${context.str.betsEndBettingTime} '),
          if (durationToEnd != null)
            BodyMedium(
              durationToEnd.toUIDuration(),
              fontWeight: FontWeight.bold,
            )
          else ...[
            const GapHorizontal8(),
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ],
      ),
    );
  }
}
