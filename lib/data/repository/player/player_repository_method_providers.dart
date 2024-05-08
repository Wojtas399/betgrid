import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/player.dart';
import 'player_repository.dart';

part 'player_repository_method_providers.g.dart';

@riverpod
Stream<Player?> player(
  PlayerRef ref, {
  required String playerId,
}) =>
    ref
        .watch(playerRepositoryProvider)
        .getPlayerById(playerId: playerId)
        .distinct();
