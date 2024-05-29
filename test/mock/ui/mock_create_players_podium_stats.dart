import 'package:betgrid/ui/screen/stats/stats_creator/create_players_podium_stats.dart';
import 'package:betgrid/ui/screen/stats/stats_model/players_podium.dart';
import 'package:mocktail/mocktail.dart';

class MockCreatePlayersPodiumStats extends Mock
    implements CreatePlayersPodiumStats {
  void mock({
    PlayersPodium? playersPodium,
  }) {
    when(call).thenAnswer((_) => Stream.value(playersPodium));
  }
}
