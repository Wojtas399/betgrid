import 'package:betgrid/data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import 'package:betgrid/model/grand_prix_bet_points.dart';
import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

@injectable
class GetGrandPrixesBetPointsUseCase {
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;

  const GetGrandPrixesBetPointsUseCase(
    this._grandPrixBetPointsRepository,
  );

  Stream<List<GrandPrixBetPoints>> call({
    required Iterable<String> playersIds,
    required Iterable<String> grandPrixesIds,
  }) {
    if (playersIds.isEmpty || grandPrixesIds.isEmpty) return Stream.value([]);
    final List<Stream<GrandPrixBetPoints?>> grandPrixesBetPoints$ = [];
    for (final playerId in playersIds) {
      for (final gpId in grandPrixesIds) {
        final gpBetPoints$ = _grandPrixBetPointsRepository
            .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: playerId,
          grandPrixId: gpId,
        );
        grandPrixesBetPoints$.add(gpBetPoints$);
      }
    }
    return Rx.combineLatest(
      grandPrixesBetPoints$,
      (List<GrandPrixBetPoints?> values) => values,
    ).map((gpsBetPoints) => gpsBetPoints.whereNotNull().toList());
  }
}
