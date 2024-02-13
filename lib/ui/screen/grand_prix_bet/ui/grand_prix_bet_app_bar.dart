import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../notifier/grand_prix_bet_notifier.dart';

class GrandPrixBetAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GrandPrixBetAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool doesStandingsListExist =
        ref.watch(grandPrixBetNotifierProvider).hasValue;

    return AppBar(
      title: const _GrandPrixName(),
      scrolledUnderElevation: 0.0,
      actions: [
        if (doesStandingsListExist) const _SaveButton(),
        const GapHorizontal8(),
      ],
    );
  }
}

class _GrandPrixName extends ConsumerWidget {
  const _GrandPrixName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String? grandPrixName = ref.watch(
      grandPrixBetNotifierProvider.select(
        (state) => state.value?.grandPrixName,
      ),
    );

    return Text(grandPrixName ?? '--');
  }
}

class _SaveButton extends ConsumerStatefulWidget {
  const _SaveButton();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SaveButtonState();
}

class _SaveButtonState extends ConsumerState<_SaveButton> {
  bool _haveChangesBeenMade = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(
      grandPrixBetNotifierProvider,
      (previous, next) {
        final listEq = const ListEquality().equals;
        final prevState = previous?.value;
        final currState = next.value;
        setState(() {
          _haveChangesBeenMade = prevState != null &&
              currState != null &&
              (!listEq(prevState.qualiStandingsByDriverIds,
                      currState.qualiStandingsByDriverIds) ||
                  prevState.p1DriverId != currState.p1DriverId ||
                  prevState.p2DriverId != currState.p2DriverId ||
                  prevState.p3DriverId != currState.p3DriverId ||
                  prevState.p10DriverId != currState.p10DriverId ||
                  prevState.fastestLapDriverId !=
                      currState.fastestLapDriverId ||
                  !listEq(prevState.dnfDriverIds, currState.dnfDriverIds) ||
                  prevState.willBeSafetyCar != currState.willBeSafetyCar ||
                  prevState.willBeRedFlag != currState.willBeRedFlag);
        });
      },
    );

    return ElevatedButton(
      onPressed: _haveChangesBeenMade
          ? ref.read(grandPrixBetNotifierProvider.notifier).saveStandings
          : null,
      child: Text(context.str.save),
    );
  }
}
