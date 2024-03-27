import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../model/player.dart';

part 'other_players_provider.g.dart';

@riverpod
Stream<List<Player>?> otherPlayers(OtherPlayersRef ref) =>
    ref.watch(authRepositoryProvider).loggedUserId$.switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? ref.watch(playerRepositoryProvider).getAllPlayers().map(
                    (List<Player>? players) => players
                        ?.where((Player player) => player.id != loggedUserId)
                        .toList(),
                  )
              : Stream.value(null),
        );
