import 'package:betgrid/ui/screen/stats/stats_maker/players_podium_maker.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:mocktail/mocktail.dart';

class MockPlayersPodiumMaker extends Mock implements PlayersPodiumMaker {
  void mock({
    PlayersPodium? playersPodium,
  }) {
    when(call).thenAnswer((_) => Stream.value(playersPodium));
  }
}
