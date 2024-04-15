import 'package:collection/collection.dart';

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

  PlayerRepositoryImpl({
    required FirebaseUserService firebaseUserService,
    required FirebaseAvatarService firebaseAvatarService,
    super.initialData,
  })  : _dbUserService = firebaseUserService,
        _dbAvatarService = firebaseAvatarService;

  @override
  Stream<List<Player>?> getAllPlayers() async* {
    if (isRepositoryStateEmpty) await _fetchAllPlayersFromDb();
    await for (final allPlayers in repositoryState$) {
      yield allPlayers;
    }
  }

  @override
  Stream<Player?> getPlayerById({required String playerId}) async* {
    await for (final players in repositoryState$) {
      Player? player = players.firstWhereOrNull(
        (player) => player.id == playerId,
      );
      player ??= await _fetchPlayerFromDb(playerId);
      yield player;
    }
  }

  Future<void> _fetchAllPlayersFromDb() async {
    final List<UserDto> userDtos = await _dbUserService.loadAllUsers();
    final List<Player> players = [];
    for (final userDto in userDtos) {
      final String? avatarUrl = await _dbAvatarService.loadAvatarUrlForUser(
        userId: userDto.id,
      );
      final Player player = mapPlayerFromUserDto(userDto, avatarUrl);
      players.add(player);
    }
    setEntities(players);
  }

  Future<Player?> _fetchPlayerFromDb(String playerId) async {
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
