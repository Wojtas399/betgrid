import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../../../../model/driver.dart';
import '../../../component/text/headline.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../riverpod_provider/all_drivers_provider.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import '../notifier/grand_prix_bet_notifier_state.dart';
import 'grand_prix_bet_additional.dart';
import 'grand_prix_bet_qualifications.dart';
import 'grand_prix_bet_race.dart';

class GrandPrixBetBody extends ConsumerWidget {
  const GrandPrixBetBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<GrandPrixBetNotifierState?> notifierState =
        ref.watch(grandPrixBetNotifierProvider);
    final AsyncValue<List<Driver>?> allDrivers = ref.watch(allDriversProvider);

    if (notifierState.hasValue && allDrivers.hasValue) {
      return CustomScrollView(
        slivers: [
          _SectionParameters.build(
            context: context,
            label: context.str.qualifications,
            table: const GrandPrixBetQualifications(),
          ),
          _SectionParameters.build(
            context: context,
            label: context.str.race,
            table: const GrandPrixBetRace(),
          ),
          _SectionParameters.build(
            context: context,
            label: context.str.additional,
            table: const GrandPrixBetAdditional(),
          ),
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class _SectionParameters extends SliverStickyHeader {
  _SectionParameters({
    super.header,
    super.sliver,
  });

  factory _SectionParameters.build({
    required BuildContext context,
    required String label,
    required Widget table,
  }) =>
      _SectionParameters(
        header: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
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
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, i) => table,
            childCount: 1,
          ),
        ),
      );
}
