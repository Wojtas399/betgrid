import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/auth/auth_repository.dart';
import '../../../dependency_injection.dart';
import 'provider/grand_prix_name_provider.dart';
import 'provider/player_id_provider.dart';
import 'provider/player_username_provider.dart';

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
    final String? playerId = ref.watch(playerIdProvider);
    final Stream<String?> loggedUserId$ =
        getIt.get<AuthRepository>().loggedUserId$;
    final AsyncValue<String?> playerUsername =
        ref.watch(playerUsernameProvider);

    return StreamBuilder(
      stream: loggedUserId$,
      builder: (_, AsyncSnapshot<String?> asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (grandPrixName is AsyncData && playerUsername is AsyncData) {
          String title = grandPrixName.value!;
          if (playerId != asyncSnapshot.data && playerUsername.value != null) {
            title += ' (${playerUsername.value})';
          }
          return Text(title);
        }
        return const Text('--');
      },
    );
  }
}
