import 'package:collection/collection.dart';

import '../../../dependency_injection.dart';
import '../../../firebase/model/user_dto/user_dto.dart';
import '../../../firebase/service/firebase_avatar_service.dart';
import '../../../firebase/service/firebase_user_service.dart';
import '../../../model/player.dart';
import '../../mapper/player_mapper.dart';
import '../repository.dart';
import 'player_repository.dart';

class PlayerRepositoryImpl extends Repository<Player>
    implements PlayerRepository {
  final FirebaseUserService _dbUserService;
  final FirebaseAvatarService _dbAvatarService;

  PlayerRepositoryImpl({super.initialData})
      : _dbUserService = getIt<FirebaseUserService>(),
        _dbAvatarService = getIt<FirebaseAvatarService>();

  @override
  Stream<List<Player>?> getAllPlayersWithoutGiven({
    required String playerId,
  }) async* {
    await _loadAllPlayersWithoutGivenFromDb(playerId);
    await for (final users in repositoryState$) {
      yield users?.where((player) => player.id != playerId).toList();
    }
  }

  @override
  Stream<Player?> getPlayerById({required String playerId}) async* {
    await for (final players in repositoryState$) {
      Player? player = players?.firstWhereOrNull(
        (player) => player.id == playerId,
      );
      player ??= await _loadPlayerFromDb(playerId);
      yield player;
    }
  }

  Future<void> _loadAllPlayersWithoutGivenFromDb(String playerId) async {
    final List<UserDto> userDtos = await _dbUserService.loadAllUsers();
    final List<Player> players = [];
    for (final userDto in userDtos) {
      if (userDto.id == playerId) continue;
      final String? avatarUrl = await _dbAvatarService.loadAvatarUrlForUser(
        userId: userDto.id,
      );
      final Player player = mapPlayerFromUserDto(userDto, avatarUrl);
      players.add(player);
    }
    setEntities(players);
  }

  Future<Player?> _loadPlayerFromDb(String playerId) async {
    final UserDto? userDto =
        await _dbUserService.loadUserById(userId: playerId);
    if (userDto == null) return null;
    final String? avatarUrl = await _dbAvatarService.loadAvatarUrlForUser(
      userId: playerId,
    );
    final Player player = mapPlayerFromUserDto(userDto, avatarUrl);
    addEntity(player);
    return player;
  }
}
