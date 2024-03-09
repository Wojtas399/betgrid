import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../model/grand_prix_bet.dart';
import '../../component/gap/gap_vertical.dart';
import '../../component/text/headline.dart';
import '../../extensions/build_context_extensions.dart';
import '../../provider/grand_prix_bet_provider.dart';
import 'grand_prix_bet_additional.dart';
import 'grand_prix_bet_qualifications.dart';
import 'grand_prix_bet_race.dart';

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
            _Label(label: context.str.qualifications),
            const GrandPrixBetQualifications(),
            _Label(label: context.str.race),
            const GrandPrixBetRace(),
            _Label(label: context.str.additional),
            const GrandPrixBetAdditional(),
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

class _Label extends StatelessWidget {
  final String label;

  const _Label({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
