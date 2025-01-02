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
    final List<GrandPrixItemParams>? grandPrixItems = context.select(
      (BetsCubit cubit) => cubit.state.grandPrixItems,
    );

    return grandPrixItems == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: grandPrixItems.length,
            itemBuilder: (_, int itemIndex) {
              final gpParams = grandPrixItems[itemIndex];

              return ScrollAnimatedItem(
                child: _Item(
                  gpParams: gpParams,
                  onPressed: () => _onGrandPrixPressed(
                    gpParams.seasonGrandPrixId,
                    context,
                  ),
                ),
              );
            },
          );
  }
}

class _Item extends StatelessWidget {
  final GrandPrixItemParams gpParams;
  final VoidCallback onPressed;

  const _Item({
    required this.gpParams,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final gpStatus = gpParams.status;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          padding: gpStatus.isOngoing || gpStatus.isNext
              ? const EdgeInsets.all(8)
              : null,
          margin: gpStatus.isOngoing || gpStatus.isNext
              ? const EdgeInsets.only(
                  top: 8,
                  left: 4,
                  right: 4,
                )
              : null,
          decoration: gpParams.status.isOngoing || gpParams.status.isNext
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
              if (gpStatus is GrandPrixStatusNext) const _EndBettingTime(),
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
        if (gpStatus.isOngoing || gpStatus.isNext)
          Positioned(
            left: 24,
            top: -4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              color: context.colorScheme.surface,
              child: TitleMedium(
                gpStatus.isOngoing ? 'Trwa' : 'Następne',
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
          const BodyMedium('Koniec typowania za '),
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
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
