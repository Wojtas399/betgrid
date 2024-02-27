import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../provider/grand_prix_name_provider.dart';

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
    return Text(
      ref.watch(grandPrixNameProvider).when(
            data: (grandPrixName) => grandPrixName ?? '--',
            error: (_, __) => 'Cannot load Grand Prix name',
            loading: () => '--',
          ),
    );
  }
}
