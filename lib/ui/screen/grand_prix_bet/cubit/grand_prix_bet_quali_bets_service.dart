import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../model/driver_details.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../use_case/get_details_of_all_drivers_from_season_use_case.dart';
import 'grand_prix_bet_cubit.dart';
import 'grand_prix_bet_state.dart';
import 'grand_prix_bet_status_service.dart';

@injectable
class GrandPrixBetQualiBetsService {
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final GetDetailsOfAllDriversFromSeasonUseCase
      _getDetailsOfAllDriversFromSeasonUseCase;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final GrandPrixBetStatusService _grandPrixBetStatusService;
  final GrandPrixBetCubitParams _params;

  GrandPrixBetQualiBetsService(
    this._grandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._getDetailsOfAllDriversFromSeasonUseCase,
    this._grandPrixBetPointsRepository,
    this._grandPrixBetStatusService,
    @factoryParam this._params,
  );

  Stream<List<SingleDriverBet>> getQualiBets() {
    return Rx.combineLatest4(
      _getBetQualiStandingsBySeasonDriverIds(),
      _getResultQualiStandingsBySeasonDriverIds(),
      _getDetailsOfAllDriversFromSeasonUseCase(_params.season),
      _getQualiBetPoints(),
      _prepareQualiBets,
    );
  }

  Stream<List<String?>?> _getBetQualiStandingsBySeasonDriverIds() {
    return _grandPrixBetRepository
        .getGrandPrixBet(
          playerId: _params.playerId,
          season: _params.season,
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map((grandPrixBet) => grandPrixBet?.qualiStandingsBySeasonDriverIds);
  }

  Stream<List<String?>?> _getResultQualiStandingsBySeasonDriverIds() {
    return _grandPrixResultsRepository
        .getGrandPrixResultsForSeasonGrandPrix(
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map(
          (grandPrixResults) =>
              grandPrixResults?.qualiStandingsBySeasonDriverIds,
        );
  }

  Stream<QualiBetPoints?> _getQualiBetPoints() {
    return _grandPrixBetPointsRepository
        .getGrandPrixBetPoints(
          playerId: _params.playerId,
          season: _params.season,
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map((grandPrixBetPoints) => grandPrixBetPoints?.qualiBetPoints);
  }

  List<SingleDriverBet> _prepareQualiBets(
    List<String?>? betQualiStandingsBySeasonDriverIds,
    List<String?>? resultQualiStandingsBySeasonDriverIds,
    List<DriverDetails> detailsOfAllDriversFromSeason,
    QualiBetPoints? qualiBetPoints,
  ) {
    final List<double?> qualiPoints = [
      qualiBetPoints?.q3P1Points,
      qualiBetPoints?.q3P2Points,
      qualiBetPoints?.q3P3Points,
      qualiBetPoints?.q3P4Points,
      qualiBetPoints?.q3P5Points,
      qualiBetPoints?.q3P6Points,
      qualiBetPoints?.q3P7Points,
      qualiBetPoints?.q3P8Points,
      qualiBetPoints?.q3P9Points,
      qualiBetPoints?.q3P10Points,
      qualiBetPoints?.q2P11Points,
      qualiBetPoints?.q2P12Points,
      qualiBetPoints?.q2P13Points,
      qualiBetPoints?.q2P14Points,
      qualiBetPoints?.q2P15Points,
      qualiBetPoints?.q1P16Points,
      qualiBetPoints?.q1P17Points,
      qualiBetPoints?.q1P18Points,
      qualiBetPoints?.q1P19Points,
      qualiBetPoints?.q1P20Points,
    ];
    return List.generate(
      20,
      (int betIndex) {
        final String? betSeasonDriverId =
            betQualiStandingsBySeasonDriverIds?[betIndex];
        final String? resultSeasonDriverId =
            resultQualiStandingsBySeasonDriverIds?[betIndex];
        final double? points = qualiPoints[betIndex];
        final betDriver = detailsOfAllDriversFromSeason.firstWhereOrNull(
          (driver) => driver.seasonDriverId == betSeasonDriverId,
        );
        final resultDriver = detailsOfAllDriversFromSeason.firstWhereOrNull(
          (driver) => driver.seasonDriverId == resultSeasonDriverId,
        );
        return SingleDriverBet(
          status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
          betDriver: betDriver,
          resultDriver: resultDriver,
          points: points,
        );
      },
    );
  }
}
