import 'package:betgrid_shared/firebase/model/user_dto.dart';
import 'package:betgrid_shared/firebase/service/firebase_avatar_service.dart';
import 'package:betgrid_shared/firebase/service/firebase_user_service.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';

import '../../../model/player.dart';
import '../../mapper/player_mapper.dart';
import '../repository.dart';
import 'player_repository.dart';

@LazySingleton(as: PlayerRepository)
class PlayerRepositoryImpl extends Repository<Player>
    implements PlayerRepository {
  final FirebaseUserService _fireUserService;
  final FirebaseAvatarService _fireAvatarService;
  final PlayerMapper _playerMapper;

  PlayerRepositoryImpl(
    this._fireUserService,
    this._fireAvatarService,
    this._playerMapper,
  );

  @override
  Stream<List<Player>> getAll() async* {
    if (isRepositoryStateEmpty) await _fetchAll();
    await for (final allPlayers in repositoryState$) {
      yield allPlayers;
    }
  }

  @override
  Stream<Player?> getById(String playerId) async* {
    await for (final players in repositoryState$) {
      Player? player = players.firstWhereOrNull(
        (player) => player.id == playerId,
      );
      player ??= await _fetchById(playerId);
      yield player;
    }
  }

  Future<void> _fetchAll() async {
    final List<UserDto> userDtos = await _fireUserService.fetchAll();
    final List<Player> players = [];
    for (final userDto in userDtos) {
      final String? avatarUrl = await _fireAvatarService.fetchUrlForUser(
        userDto.id,
      );
      final Player player = _playerMapper.mapFromDto(
        userDto: userDto,
        avatarUrl: avatarUrl,
      );
      players.add(player);
    }
    setEntities(players);
  }

  Future<Player?> _fetchById(String playerId) async {
    final UserDto? userDto = await _fireUserService.fetchById(playerId);
    if (userDto == null) return null;
    final String? avatarUrl = await _fireAvatarService.fetchUrlForUser(
      playerId,
    );
    final Player player = _playerMapper.mapFromDto(
      userDto: userDto,
      avatarUrl: avatarUrl,
    );
    addEntity(player);
    return player;
  }
}
