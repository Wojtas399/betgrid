import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';
import 'player_id_provider.dart';

part 'player_username_provider.g.dart';

@Riverpod(dependencies: [playerId])
Stream<String?> playerUsername(PlayerUsernameRef ref) {
  final String? selectedPlayerId = ref.watch(playerIdProvider);
  return selectedPlayerId == null
      ? Stream.value(null)
      : ref
          .watch(authRepositoryProvider)
          .loggedUserId$
          .switchMap(
            (String? loggedUserId) =>
                loggedUserId == null || loggedUserId == selectedPlayerId
                    ? Stream.value(null)
                    : ref
                        .watch(playerRepositoryProvider)
                        .getPlayerById(playerId: selectedPlayerId),
          )
          .map((Player? player) => player?.username);
}
