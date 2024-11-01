import 'package:collection/collection.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/driver/driver_repository.dart';
import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet_points.dart';
import 'grand_prix_bet_state.dart';
import 'grand_prix_bet_status_service.dart';

@injectable
class GrandPrixBetQualiBetsService {
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final DriverRepository _driverRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final GrandPrixBetStatusService _grandPrixBetStatusService;
  final String _playerId;
  final String _grandPrixId;

  GrandPrixBetQualiBetsService(
    this._grandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._driverRepository,
    this._grandPrixBetPointsRepository,
    this._grandPrixBetStatusService,
    @factoryParam this._playerId,
    @factoryParam this._grandPrixId,
  );

  Stream<List<SingleDriverBet>> getQualiBets() {
    return Rx.combineLatest4(
      _getBetQualiStandingsByDriverIds(),
      _getResultQualiStandingsByDriverIds(),
      _driverRepository.getAllDrivers(),
      _getQualiBetPoints(),
      _prepareQualiBets,
    );
  }

  Stream<List<String?>?> _getBetQualiStandingsByDriverIds() {
    return _grandPrixBetRepository
        .getGrandPrixBetForPlayerAndGrandPrix(
          playerId: _playerId,
          grandPrixId: _grandPrixId,
        )
        .map((grandPrixBet) => grandPrixBet?.qualiStandingsByDriverIds);
  }

  Stream<List<String?>?> _getResultQualiStandingsByDriverIds() {
    return _grandPrixResultsRepository
        .getGrandPrixResultsForGrandPrix(grandPrixId: _grandPrixId)
        .map((grandPrixResults) => grandPrixResults?.qualiStandingsByDriverIds);
  }

  Stream<QualiBetPoints?> _getQualiBetPoints() {
    return _grandPrixBetPointsRepository
        .getGrandPrixBetPointsForPlayerAndGrandPrix(
          playerId: _playerId,
          grandPrixId: _grandPrixId,
        )
        .map((grandPrixBetPoints) => grandPrixBetPoints?.qualiBetPoints);
  }

  List<SingleDriverBet> _prepareQualiBets(
    List<String?>? betQualiStandingsByDriverIds,
    List<String?>? resultQualiStandingsByDriverIds,
    List<Driver> allDrivers,
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
        final String? betDriverId = betQualiStandingsByDriverIds?[betIndex];
        final String? resultDriverId =
            resultQualiStandingsByDriverIds?[betIndex];
        final double? points = qualiPoints[betIndex];

        return SingleDriverBet(
          status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
          betDriver: allDrivers.firstWhereOrNull(
            (Driver driver) => driver.id == betDriverId,
          ),
          resultDriver: allDrivers.firstWhereOrNull(
            (Driver driver) => driver.id == resultDriverId,
          ),
          points: points,
        );
      },
    );
  }
}
