import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../notifier/grand_prix_bet_notifier.dart';
import '../notifier/grand_prix_bet_notifier_state.dart';

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
  GrandPrixBetNotifierState? _initialNotifierState;
  bool _haveChangesBeenMade = false;

  bool _areNotifierStatesDifferent(
    GrandPrixBetNotifierState state1,
    GrandPrixBetNotifierState state2,
  ) {
    final listEq = const ListEquality().equals;
    return (!listEq(state1.qualiStandingsByDriverIds,
            state2.qualiStandingsByDriverIds) ||
        state1.p1DriverId != state2.p1DriverId ||
        state1.p2DriverId != state2.p2DriverId ||
        state1.p3DriverId != state2.p3DriverId ||
        state1.p10DriverId != state2.p10DriverId ||
        state1.fastestLapDriverId != state2.fastestLapDriverId ||
        !listEq(state1.dnfDriverIds, state2.dnfDriverIds) ||
        state1.willBeSafetyCar != state2.willBeSafetyCar ||
        state1.willBeRedFlag != state2.willBeRedFlag);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
      grandPrixBetNotifierProvider,
      (previous, next) {
        final prevState = previous?.value;
        final currState = next.value;
        setState(() {
          _initialNotifierState ??= currState;
          _haveChangesBeenMade = _initialNotifierState != null &&
                  currState != null
              ? _areNotifierStatesDifferent(_initialNotifierState!, currState)
              : prevState != null &&
                  currState != null &&
                  _areNotifierStatesDifferent(prevState, currState);
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
