import '../../../model/player.dart';

abstract interface class PlayerRepository {
  Stream<List<Player>> getAll();

  Stream<Player?> getById(String playerId);
}
