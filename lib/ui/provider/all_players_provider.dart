import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../auth/auth_service.dart';
import '../../data/repository/player/player_repository.dart';
import '../../model/player.dart';

part 'all_players_provider.g.dart';

@riverpod
Stream<List<Player>?> allPlayers(AllPlayersRef ref) =>
    ref.watch(authServiceProvider).loggedUserId$.switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? ref
                  .watch(playerRepositoryProvider)
                  .getAllPlayersWithoutGiven(playerId: loggedUserId)
              : Stream.value(null),
        );
