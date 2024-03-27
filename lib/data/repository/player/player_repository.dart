import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/player.dart';
import 'player_repository_impl.dart';

part 'player_repository.g.dart';

abstract interface class PlayerRepository {
  Stream<List<Player>?> getAllPlayers();

  Stream<Player?> getPlayerById({required String playerId});
}

@riverpod
PlayerRepository playerRepository(PlayerRepositoryRef ref) =>
    PlayerRepositoryImpl();
