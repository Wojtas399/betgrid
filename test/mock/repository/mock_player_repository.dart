import 'package:betgrid/data/repository/player/player_repository.dart';
import 'package:betgrid/model/player.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayerRepository extends Mock implements PlayerRepository {
  void mockGetAll({required List<Player> players}) {
    when(getAll).thenAnswer((_) => Stream.value(players));
  }

  void mockGetById({Player? player}) {
    when(() => getById(any())).thenAnswer((_) => Stream.value(player));
  }
}
