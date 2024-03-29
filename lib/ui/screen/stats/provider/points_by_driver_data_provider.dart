import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../data/repository/player/player_repository_method_providers.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/player.dart';
import 'finished_grand_prixes_provider.dart';
import 'points_for_driver_in_grand_prix_provider.dart';

part 'points_by_driver_data_provider.g.dart';

@riverpod
class PointsByDriverDataProvider extends _$PointsByDriverDataProvider {
  @override
  Future<List<PointsByDriverPlayerPoints>> build() async =>
      <PointsByDriverPlayerPoints>[];

  Future<void> onDriverChanged(String driverId) async {
    state = const AsyncLoading<List<PointsByDriverPlayerPoints>>();
    final List<Player>? allPlayers = await ref.watch(allPlayersProvider.future);
    if (allPlayers == null) {
      state = const AsyncData<List<PointsByDriverPlayerPoints>>([]);
      return;
    }
    final List<GrandPrix> finishedGrandPrixes = await ref.watch(
      finishedGrandPrixesProvider.future,
    );
    final List<PointsByDriverPlayerPoints> playersPoints = [];
    for (final player in allPlayers) {
      double points = 0.0;
      for (final grandPrix in finishedGrandPrixes) {
        final pointsForGp = await ref.watch(
          pointsForDriverInGrandPrixProvider(
            playerId: player.id,
            grandPrixId: grandPrix.id,
            driverId: driverId,
          ).future,
        );
        points += pointsForGp;
      }
      playersPoints.add(
        PointsByDriverPlayerPoints(
          player: player,
          points: points,
        ),
      );
    }
    state = AsyncData(playersPoints);
  }
}

class PointsByDriverPlayerPoints extends Equatable {
  final Player player;
  final double points;

  const PointsByDriverPlayerPoints({
    required this.player,
    required this.points,
  });

  @override
  List<Object?> get props => [player, points];
}
