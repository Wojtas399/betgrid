import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix_bet.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text_component.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix/grand_prix_id_provider.dart';
import '../../provider/grand_prix_bet_points_provider.dart';
import '../../provider/player/player_id_provider.dart';
import 'grand_prix_bet_qualifications.dart';
import 'grand_prix_bet_race.dart';
import 'provider/grand_prix_bet_provider.dart';

class GrandPrixBetBody extends ConsumerWidget {
  const GrandPrixBetBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GrandPrixBet?> grandPrixBet =
        ref.watch(grandPrixBetProvider);

    if (grandPrixBet.value != null) {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GapVertical16(),
            const _TotalPoints(),
            const GapVertical16(),
            _Label(label: context.str.qualifications),
            const GrandPrixBetQualifications(),
            _Label(label: context.str.race),
            const GrandPrixBetRace(),
            const GapVertical32(),
          ],
        ),
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _TotalPoints extends ConsumerWidget {
  const _TotalPoints();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? playerId = ref.watch(playerIdProvider);
    final String? grandPrixId = ref.watch(grandPrixIdProvider);
    double? totalPoints;
    if (playerId != null && grandPrixId != null) {
      totalPoints = ref.watch(
        grandPrixBetPointsProvider(
          playerId: playerId,
          grandPrixId: grandPrixId,
        ).select((state) => state.value?.totalPoints),
      );
    }

    return Center(
      child: Column(
        children: [
          HeadlineMedium(
            context.str.points,
            fontWeight: FontWeight.bold,
          ),
          const GapVertical8(),
          DisplayLarge(
            '${totalPoints ?? '--'}',
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String label;

  const _Label({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
          ),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 16, left: 24, top: 16),
      child: HeadlineMedium(
        label,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
