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
import '../cubit/bets_cubit.dart';
import '../cubit/bets_state.dart';

class BetsListOfBets extends StatelessWidget {
  const BetsListOfBets({super.key});

  void _onGrandPrixPressed(GrandPrixItemParams gpParams, BuildContext context) {
    final BetsCubit cubit = context.read<BetsCubit>();
    final int? season = cubit.state.season;
    final String? loggedUserId = cubit.state.loggedUserId;
    if (loggedUserId != null && season != null) {
      if (gpParams.status.isOngoing || gpParams.status.isFinished) {
        context.navigateTo(
          SeasonGrandPrixBetPreviewRoute(
            playerId: loggedUserId,
            season: season,
            seasonGrandPrixId: gpParams.seasonGrandPrixId,
          ),
        );
      } else if (gpParams.status.isNext || gpParams.status.isUpcoming) {
        context.navigateTo(
          SeasonGrandPrixBetEditorRoute(
            season: season,
            seasonGrandPrixId: gpParams.seasonGrandPrixId,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<GrandPrixItemParams>? grandPrixItems = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixItems,
    );
    final bool doesOngoingGpExist = context.select(
      (BetsCubit cubit) => cubit.state.doesOngoingGpExist,
    );

    return grandPrixItems == null
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: grandPrixItems.length,
          itemBuilder: (_, int itemIndex) {
            final gpParams = grandPrixItems[itemIndex];

            return ScrollAnimatedItem(
              child: _Item(
                gpParams: gpParams,
                doesOngoingGpExist: doesOngoingGpExist,
                onPressed: () => _onGrandPrixPressed(gpParams, context),
              ),
            );
          },
        );
  }
}

class _Item extends StatelessWidget {
  final GrandPrixItemParams gpParams;
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
      (BetsCubit cubit) => cubit.state.durationToStartNextGp,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          BodyMedium('${context.str.betsEndBettingTime} '),
          if (durationToEnd != null)
            BodyMedium(
              durationToEnd.toDaysHoursMinutes(),
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
