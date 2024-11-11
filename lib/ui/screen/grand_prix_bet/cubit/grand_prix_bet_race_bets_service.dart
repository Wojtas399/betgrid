import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../model/driver.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../use_case/get_driver_based_on_season_driver_use_case.dart';
import 'grand_prix_bet_state.dart';
import 'grand_prix_bet_status_service.dart';

@injectable
class GrandPrixBetRaceBetsService {
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final GetDriverBasedOnSeasonDriverUseCase
      _getDriverBasedOnSeasonDriverUseCase;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final GrandPrixBetStatusService _grandPrixBetStatusService;
  final String _playerId;
  final String _seasonGrandPrix;

  GrandPrixBetRaceBetsService(
    this._grandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._seasonDriverRepository,
    this._getDriverBasedOnSeasonDriverUseCase,
    this._grandPrixBetPointsRepository,
    this._grandPrixBetStatusService,
    @factoryParam this._playerId,
    @factoryParam this._seasonGrandPrix,
  );

  Stream<List<SingleDriverBet>> getPodiumBets() {
    return Rx.combineLatest3(
      _getBetPodiumDrivers(),
      _getResultPodiumDrivers(),
      _getPodiumPoints(),
      (
        List<Driver?> betDrivers,
        List<Driver?> resultDrivers,
        List<double?> points,
      ) =>
          List.generate(
        3,
        (int positionIndex) => SingleDriverBet(
          status: _grandPrixBetStatusService.selectStatusBasedOnPoints(
            points[positionIndex],
          ),
          betDriver: betDrivers[positionIndex],
          resultDriver: resultDrivers[positionIndex],
          points: points[positionIndex],
        ),
      ),
    );
  }

  Stream<SingleDriverBet> getP10Bet() {
    return Rx.combineLatest3(
      _getBetP10Driver(),
      _getResultP10Driver(),
      _getPoints().map((points) => points?.p10Points),
      (
        Driver? betDriver,
        Driver? resultDriver,
        double? points,
      ) =>
          SingleDriverBet(
        status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
        betDriver: betDriver,
        resultDriver: resultDriver,
        points: points,
      ),
    );
  }

  Stream<SingleDriverBet> getFastestLapBet() {
    return Rx.combineLatest3(
      _getBetFastestLapDriver(),
      _getResultFastestLapDriver(),
      _getPoints().map((points) => points?.fastestLapPoints),
      (
        Driver? betDriver,
        Driver? resultDriver,
        double? points,
      ) =>
          SingleDriverBet(
        status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
        betDriver: betDriver,
        resultDriver: resultDriver,
        points: points,
      ),
    );
  }

  Stream<MultipleDriversBet> getDnfDriversBet() {
    return Rx.combineLatest3(
      _getBetDnfDrivers(),
      _getResultDnfDrivers(),
      _getPoints().map((points) => points?.dnfPoints),
      (
        List<Driver?>? betDrivers,
        List<Driver?>? resultDrivers,
        double? points,
      ) =>
          MultipleDriversBet(
        status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
        betDrivers: betDrivers,
        resultDrivers: resultDrivers,
        points: points,
      ),
    );
  }

  Stream<BooleanBet> getSafetyCarBet() {
    return Rx.combineLatest3(
      _getBets().map((grandPrixBet) => grandPrixBet?.willBeSafetyCar),
      _getResults().map((raceResults) => raceResults?.wasThereSafetyCar),
      _getPoints().map((points) => points?.safetyCarPoints),
      (
        bool? predictionWhetherWillBeSafetyCar,
        bool? resultWhetherWasSafetyCar,
        double? points,
      ) =>
          BooleanBet(
        status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
        betValue: predictionWhetherWillBeSafetyCar,
        resultValue: resultWhetherWasSafetyCar,
        points: points,
      ),
    );
  }

  Stream<BooleanBet> getRedFlagBet() {
    return Rx.combineLatest3(
      _getBets().map((grandPrixBet) => grandPrixBet?.willBeRedFlag),
      _getResults().map((raceResults) => raceResults?.wasThereRedFlag),
      _getPoints().map((points) => points?.redFlagPoints),
      (
        bool? predictionWhetherWillBeRedFlag,
        bool? resultWhetherWasRedFlag,
        double? points,
      ) =>
          BooleanBet(
        status: _grandPrixBetStatusService.selectStatusBasedOnPoints(points),
        betValue: predictionWhetherWillBeRedFlag,
        resultValue: resultWhetherWasRedFlag,
        points: points,
      ),
    );
  }

  Stream<List<Driver?>> _getBetPodiumDrivers() {
    return _getBets()
        .map(
          (GrandPrixBet? grandPrixBet) => [
            grandPrixBet?.p1SeasonDriverId,
            grandPrixBet?.p2SeasonDriverId,
            grandPrixBet?.p3SeasonDriverId,
          ],
        )
        .switchMap(_getCorrespondingDriversList);
  }

  Stream<List<Driver?>> _getResultPodiumDrivers() {
    return _getResults()
        .map(
          (RaceResults? raceResults) => [
            raceResults?.p1SeasonDriverId,
            raceResults?.p2SeasonDriverId,
            raceResults?.p3SeasonDriverId,
          ],
        )
        .switchMap(_getCorrespondingDriversList);
  }

  Stream<List<double?>> _getPodiumPoints() {
    return _getPoints().map(
      (RaceBetPoints? points) => [
        points?.p1Points,
        points?.p2Points,
        points?.p3Points,
      ],
    );
  }

  Stream<Driver?> _getBetP10Driver() {
    return _getBets()
        .map((grandPrixBet) => grandPrixBet?.p10SeasonDriverId)
        .switchMap(_getCorrespondingDriver);
  }

  Stream<Driver?> _getResultP10Driver() {
    return _getResults()
        .map((raceResults) => raceResults?.p10SeasonDriverId)
        .switchMap(_getCorrespondingDriver);
  }

  Stream<Driver?> _getBetFastestLapDriver() {
    return _getBets()
        .map((grandPrixBet) => grandPrixBet?.fastestLapSeasonDriverId)
        .switchMap(_getCorrespondingDriver);
  }

  Stream<Driver?> _getResultFastestLapDriver() {
    return _getResults()
        .map((raceResults) => raceResults?.fastestLapSeasonDriverId)
        .switchMap(_getCorrespondingDriver);
  }

  Stream<List<Driver?>?> _getBetDnfDrivers() {
    return _getBets()
        .map((grandPrixBet) => grandPrixBet?.dnfSeasonDriverIds)
        .switchMap(
          (dnfSeasonDriverIds) => dnfSeasonDriverIds != null
              ? _getCorrespondingDriversList(dnfSeasonDriverIds)
              : Stream.value(null),
        );
  }

  Stream<List<Driver?>?> _getResultDnfDrivers() {
    return _getResults()
        .map((raceResults) => raceResults?.dnfSeasonDriverIds)
        .switchMap(
          (dnfDriverIds) => dnfDriverIds != null
              ? _getCorrespondingDriversList(dnfDriverIds)
              : Stream.value(null),
        );
  }

  Stream<GrandPrixBet?> _getBets() {
    return _grandPrixBetRepository.getGrandPrixBetForPlayerAndSeasonGrandPrix(
      playerId: _playerId,
      seasonGrandPrixId: _seasonGrandPrix,
    );
  }

  Stream<RaceResults?> _getResults() {
    return _grandPrixResultsRepository
        .getGrandPrixResultsForSeasonGrandPrix(
          seasonGrandPrixId: _seasonGrandPrix,
        )
        .map((grandPrixResults) => grandPrixResults?.raceResults);
  }

  Stream<RaceBetPoints?> _getPoints() {
    return _grandPrixBetPointsRepository
        .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
          playerId: _playerId,
          seasonGrandPrixId: _seasonGrandPrix,
        )
        .map((grandPrixBetPoints) => grandPrixBetPoints?.raceBetPoints);
  }

  Stream<List<Driver?>> _getCorrespondingDriversList(List<String?> driverIds) {
    return Rx.combineLatest(
      driverIds.map(_getCorrespondingDriver),
      (driverStreams) => driverStreams,
    );
  }

  Stream<Driver?> _getCorrespondingDriver(String? driverId) {
    return driverId != null
        ? _seasonDriverRepository.getSeasonDriverById(driverId).switchMap(
              (seasonDriver) => seasonDriver != null
                  ? _getDriverBasedOnSeasonDriverUseCase(seasonDriver)
                  : Stream.value(null),
            )
        : Stream.value(null);
  }
}
