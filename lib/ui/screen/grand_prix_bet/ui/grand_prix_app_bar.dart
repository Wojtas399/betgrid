import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../component/gap/gap_horizontal.dart';
import '../../../extensions/build_context_extensions.dart';
import '../../../riverpod_provider/grand_prix_name_provider.dart';
import '../provider/grand_prix_bet_qualifications_notifier.dart';

class GrandPrixAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GrandPrixAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool doesStandingsListExist =
        ref.watch(grandPrixBetQualificationsNotifierProvider).hasValue;

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
    final AsyncValue<String?> grandPrixName = ref.watch(grandPrixNameProvider);

    return Text(grandPrixName.value ?? '--');
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
      grandPrixBetQualificationsNotifierProvider,
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
              .read(grandPrixBetQualificationsNotifierProvider.notifier)
              .saveStandings
          : null,
      child: Text(context.str.save),
    );
  }
}
