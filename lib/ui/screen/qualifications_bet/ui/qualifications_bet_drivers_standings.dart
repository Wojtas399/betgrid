import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../component/gap/gap_vertical.dart';
import '../../../component/text/title.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../riverpod_provider/all_drivers/all_drivers_provider.dart';
import '../../../riverpod_provider/grand_prix_bet/grand_prix_bet_notifier_provider.dart';
import 'qualifications_bet_position_item.dart';

class QualificationsBetDriversStandings extends ConsumerStatefulWidget {
  final String grandPrixId;

  const QualificationsBetDriversStandings({
    super.key,
    required this.grandPrixId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<QualificationsBetDriversStandings> {
  List<String?>? _standingsByDriverIds;

  void _onBeginDriverOrdering() {
    setState(() {
      _standingsByDriverIds = List.generate(20, (_) => null);
    });
  }

  void _onPositionDriverChanged(int position, String driverId) {
    final List<String?> updatedStandings = [...?_standingsByDriverIds];
    updatedStandings[position - 1] = driverId;
    setState(() {
      _standingsByDriverIds = updatedStandings;
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      grandPrixBetNotifierProvider(widget.grandPrixId).select(
        (AsyncValue<GrandPrixBet?> asyncValue) =>
            asyncValue.value?.qualiStandingsByDriverIds,
      ),
      (_, List<String>? qualiStandingsByDriverIds) {
        setState(() {
          _standingsByDriverIds = [...?qualiStandingsByDriverIds];
        });
      },
    );

    return _standingsByDriverIds?.isNotEmpty == true
        ? _Standings(
            standingsByDriverIds: _standingsByDriverIds!,
            onPositionDriverChanged: _onPositionDriverChanged,
          )
        : _NoStandingsInfo(
            onBeginDriverOrdering: _onBeginDriverOrdering,
          );
  }
}

class _NoStandingsInfo extends StatelessWidget {
  final VoidCallback onBeginDriverOrdering;

  const _NoStandingsInfo({required this.onBeginDriverOrdering});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    return FutureBuilder(
      future: ref.read(allDriversProvider.future),
      builder: (_, AsyncSnapshot<List<Driver>?> snapshot) {
        if (snapshot.hasData) {
          final List<Driver> allDrivers = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemBuilder: (_, int itemIndex) => QualificationsBetPositionItem(
              selectedDriverId: standingsByDriverIds[itemIndex],
              position: itemIndex + 1,
              allDrivers: allDrivers,
              onDriverSelected: (String driverId) {
                onPositionDriverChanged(itemIndex + 1, driverId);
              },
            ),
            separatorBuilder: (
              BuildContext context,
              int separatorIndex,
            ) =>
                Divider(
              thickness: 0.5,
              color: Theme.of(context).colorScheme.outline.withOpacity(0.75),
            ),
            itemCount: allDrivers.length,
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
