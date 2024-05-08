import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/player.dart';

part 'other_players_provider.g.dart';

@riverpod
Future<List<Player>?> otherPlayers(OtherPlayersRef ref) async {
  final String? loggedUserId =
      await getIt.get<AuthRepository>().loggedUserId$.first;
  if (loggedUserId == null) return null;
  final List<Player>? allPlayers =
      await getIt.get<PlayerRepository>().getAllPlayers().first;
  return allPlayers
      ?.where((Player player) => player.id != loggedUserId)
      .toList();
}
