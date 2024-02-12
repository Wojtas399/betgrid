import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../riverpod_provider/grand_prix_id/grand_prix_id_provider.dart';
import '../provider/qualifications_bet_drivers_standings_provider.dart';
import 'qualifications_bet_standings_list.dart';

@RoutePage()
class QualificationsBetScreen extends StatelessWidget {
  final String? grandPrixId;

  const QualificationsBetScreen({
    super.key,
    @PathParam('grandPrixId') this.grandPrixId,
  });

  @override
  Widget build(BuildContext context) {
    if (grandPrixId == null) {
      return const Text('Page not found');
    }

    return ProviderScope(
      overrides: [
        grandPrixIdProvider.overrideWithValue(grandPrixId),
      ],
      child: const Scaffold(
        appBar: _AppBar(),
        body: SafeArea(
          child: QualificationsBetStandingsList(),
        ),
      ),
    );
  }
}

class _AppBar extends ConsumerWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool doesStandingsListExist =
        ref.watch(qualificationsBetDriversStandingsProvider).hasValue;

    return AppBar(
      title: Text(context.str.qualifications),
      actions: [
        if (doesStandingsListExist) const _SaveButton(),
        const GapHorizontal8(),
      ],
    );
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
      qualificationsBetDriversStandingsProvider,
      (previous, next) {
        final eq = const ListEquality().equals;
        setState(() {
          _haveChangesBeenMade = previous?.value != null &&
              next.value != null &&
              !eq(previous!.value, next.value);
        });
      },
    );

    return ElevatedButton(
      onPressed: _haveChangesBeenMade
          ? ref
              .read(qualificationsBetDriversStandingsProvider.notifier)
              .saveStandings
          : null,
      child: Text(context.str.save),
    );
  }
}
