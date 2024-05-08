import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../firebase/service/firebase_avatar_service.dart';
import '../../../firebase/service/firebase_user_service.dart';
import '../../../model/player.dart';
import 'player_repository_impl.dart';

part 'player_repository.g.dart';

abstract interface class PlayerRepository {
  Stream<List<Player>?> getAllPlayers();

  Stream<Player?> getPlayerById({required String playerId});
}

@Riverpod(keepAlive: true)
PlayerRepository playerRepository(PlayerRepositoryRef ref) =>
    PlayerRepositoryImpl(
      ref.read(firebaseUserServiceProvider),
      ref.read(firebaseAvatarServiceProvider),
    );
