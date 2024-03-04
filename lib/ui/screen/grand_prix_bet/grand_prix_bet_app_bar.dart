import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../provider/grand_prix_name_provider.dart';
import '../../provider/player_username_provider.dart';

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
    final AsyncValue<String?> grandPrixName = ref.watch(grandPrixNameProvider);
    final AsyncValue<String?> playerUsername =
        ref.watch(playerUsernameProvider);

    if (grandPrixName is AsyncData && playerUsername is AsyncData) {
      String title = grandPrixName.value!;
      if (playerUsername.value != null) title += ' (${playerUsername.value})';
      return Text(title);
    }
    return const Text('--');
  }
}
