import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerRepository extends Mock implements PlayerRepository {
  void mockGetAllPlayersWithoutGiven({List<Player>? players}) {
    when(
      () => getAllPlayersWithoutGiven(
        playerId: any(named: 'playerId'),
      ),
    ).thenAnswer((_) => Stream.value(players));
  }
}
