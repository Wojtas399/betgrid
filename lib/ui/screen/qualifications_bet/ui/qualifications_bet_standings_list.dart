import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/headline.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../riverpod_provider/all_drivers/all_drivers_provider.dart';
import '../provider/qualifications_bet_drivers_standings_provider.dart';
import '../provider/qualifications_bet_grand_prix_name_provider.dart';
import 'qualifications_bet_position_item.dart';

class QualificationsBetStandingsList extends ConsumerWidget {
  const QualificationsBetStandingsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<String?>?> asyncValue = ref.watch(
      qualificationsBetDriversStandingsProvider,
    );

    return asyncValue.value?.isNotEmpty == true
        ? _Standings(
            standingsByDriverIds: asyncValue.value!,
            onPositionDriverChanged: ref
                .read(qualificationsBetDriversStandingsProvider.notifier)
                .onPositionDriverChanged,
          )
        : _NoStandingsInfo(
            onBeginDriverOrdering: ref
                .read(qualificationsBetDriversStandingsProvider.notifier)
                .onBeginDriversOrdering,
          );
  }
}

class _GrandPrixName extends ConsumerWidget {
  const _GrandPrixName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<String?> asyncValue = ref.watch(
      qualificationsBetGrandPrixNameProvider,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          HeadlineMedium(
            '${asyncValue.value}',
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}

class _NoStandingsInfo extends StatelessWidget {
  final VoidCallback onBeginDriverOrdering;

  const _NoStandingsInfo({required this.onBeginDriverOrdering});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _GrandPrixName(),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TitleLarge(
                  context.str.qualificationsBetNoBetInfoTitle,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                ),
                const GapVertical32(),
                ElevatedButton(
                  onPressed: onBeginDriverOrdering,
                  child: Text(context.str.qualificationsBetStartBetting),
                ),
              ],
            ),
          ),
        ),
        const GapVertical32(),
      ],
    );
  }
}

class _Standings extends ConsumerWidget {
  final List<String?> standingsByDriverIds;
  final Function(int, String) onPositionDriverChanged;

  const _Standings({
    required this.standingsByDriverIds,
    required this.onPositionDriverChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const _GrandPrixName(),
          FutureBuilder(
            future: ref.read(allDriversProvider.future),
            builder: (_, AsyncSnapshot snapshot) => snapshot.hasData
                ? Column(
                    children: snapshot.data!
                        .asMap()
                        .entries
                        .map<Widget>(
                          (entry) => QualificationsBetPositionItem(
                            selectedDriverId: standingsByDriverIds[entry.key],
                            position: entry.key + 1,
                            allDrivers: snapshot.data!,
                            onDriverSelected: (String driverId) {
                              onPositionDriverChanged(entry.key + 1, driverId);
                            },
                          ),
                        )
                        .toList(),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
