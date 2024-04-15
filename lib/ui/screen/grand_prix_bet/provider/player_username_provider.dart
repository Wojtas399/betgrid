import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/player/player_repository_method_providers.dart';
import '../../../../model/player.dart';
import 'player_id_provider.dart';

part 'player_username_provider.g.dart';

@Riverpod(dependencies: [playerId])
Future<String?> playerUsername(PlayerUsernameRef ref) async {
  final String? selectedPlayerId = ref.watch(playerIdProvider);
  return selectedPlayerId != null
      ? await ref.watch(
          playerProvider(playerId: selectedPlayerId).selectAsync(
            (Player? player) => player?.username,
          ),
        )
      : null;
}
