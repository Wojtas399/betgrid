import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/player.dart';
import 'player_repository_impl.dart';

part 'player_repository.g.dart';

@riverpod
PlayerRepository playerRepository(PlayerRepositoryRef ref) =>
    PlayerRepositoryImpl();

abstract interface class PlayerRepository {
  Stream<List<Player>?> getAllPlayersWithoutGiven({required String userId});
}
