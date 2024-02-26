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
    required String userId,
  }) async* {
    await _loadAllPlayersWithoutGivenFromDb(userId);
    await for (final users in repositoryState$) {
      yield users?.where((player) => player.id != userId).toList();
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
}
