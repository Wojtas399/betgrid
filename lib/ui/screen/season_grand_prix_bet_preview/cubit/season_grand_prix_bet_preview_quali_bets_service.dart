import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/season_grand_prix_bet/season_grand_prix_bet_repository.dart';
import '../../../../data/repository/season_grand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import '../../../../data/repository/season_grand_prix_result/season_grand_prix_results_repository.dart';
import '../../../../model/driver_details.dart';
import '../../../../model/season_grand_prix_bet_points.dart';
import '../../../../use_case/get_details_of_all_drivers_from_season_use_case.dart';
import 'season_grand_prix_bet_preview_cubit.dart';
import 'season_grand_prix_bet_preview_state.dart';
import 'season_grand_prix_bet_preview_status_service.dart';

@injectable
class SeasonGrandPrixBetPreviewQualiBetsService {
  final SeasonGrandPrixBetRepository _seasonGrandPrixBetRepository;
  final SeasonGrandPrixResultsRepository _seasonGrandPrixResultsRepository;
  final GetDetailsOfAllDriversFromSeasonUseCase
  _getDetailsOfAllDriversFromSeasonUseCase;
  final SeasonGrandPrixBetPointsRepository _seasonGrandPrixBetPointsRepository;
  final SeasonGrandPrixBetPreviewStatusService _grandPrixBetStatusService;
  final GrandPrixBetCubitParams _params;

  SeasonGrandPrixBetPreviewQualiBetsService(
    this._seasonGrandPrixBetRepository,
    this._seasonGrandPrixResultsRepository,
    this._getDetailsOfAllDriversFromSeasonUseCase,
    this._seasonGrandPrixBetPointsRepository,
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
    return _seasonGrandPrixBetRepository
        .getSeasonGrandPrixBet(
          playerId: _params.playerId,
          season: _params.season,
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map((grandPrixBet) => grandPrixBet?.qualiStandingsBySeasonDriverIds);
  }

  Stream<List<String?>?> _getResultQualiStandingsBySeasonDriverIds() {
    return _seasonGrandPrixResultsRepository
        .getResultsForSeasonGrandPrix(
          season: _params.season,
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map(
          (grandPrixResults) =>
              grandPrixResults?.qualiStandingsBySeasonDriverIds,
        );
  }

  Stream<QualiBetPoints?> _getQualiBetPoints() {
    return _seasonGrandPrixBetPointsRepository
        .getSeasonGrandPrixBetPoints(
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
      qualiBetPoints?.q3P1,
      qualiBetPoints?.q3P2,
      qualiBetPoints?.q3P3,
      qualiBetPoints?.q3P4,
      qualiBetPoints?.q3P5,
      qualiBetPoints?.q3P6,
      qualiBetPoints?.q3P7,
      qualiBetPoints?.q3P8,
      qualiBetPoints?.q3P9,
      qualiBetPoints?.q3P10,
      qualiBetPoints?.q2P11,
      qualiBetPoints?.q2P12,
      qualiBetPoints?.q2P13,
      qualiBetPoints?.q2P14,
      qualiBetPoints?.q2P15,
      qualiBetPoints?.q1P16,
      qualiBetPoints?.q1P17,
      qualiBetPoints?.q1P18,
      qualiBetPoints?.q1P19,
      qualiBetPoints?.q1P20,
    ];
    return List.generate(20, (int betIndex) {
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
    });
  }
}
