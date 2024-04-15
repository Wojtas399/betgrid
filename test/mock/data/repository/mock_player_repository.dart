import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerRepository extends Mock implements PlayerRepository {
  void mockGetAllPlayers({List<Player>? players}) {
    when(getAllPlayers).thenAnswer((_) => Stream.value(players));
  }

  void mockGetPlayerById({Player? player}) {
    when(
      () => getPlayerById(
        playerId: any(named: 'playerId'),
      ),
    ).thenAnswer((invocation) => Stream.value(player));
  }
}
