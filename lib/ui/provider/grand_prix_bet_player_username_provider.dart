import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/player/player_repository.dart';
import '../../model/player.dart';
import 'player_id_provider.dart';

part 'grand_prix_bet_player_username_provider.g.dart';

@Riverpod(dependencies: [playerId])
Stream<String?> grandPrixBetPlayerUsername(GrandPrixBetPlayerUsernameRef ref) {
  final String? selectedPlayerId = ref.watch(playerIdProvider);
  return selectedPlayerId == null
      ? Stream.value(null)
      : ref
          .watch(authServiceProvider)
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
