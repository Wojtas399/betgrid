import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifier/grand_prix_bet_notifier.dart';

class GrandPrixBetAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GrandPrixBetAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const _GrandPrixName(),
      scrolledUnderElevation: 0.0,
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
