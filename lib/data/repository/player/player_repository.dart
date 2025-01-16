import '../../../model/player.dart';

abstract interface class PlayerRepository {
  Stream<List<Player>> getAllPlayers();

  Stream<Player?> getPlayerById({required String playerId});
}
