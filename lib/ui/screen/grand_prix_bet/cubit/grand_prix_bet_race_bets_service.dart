import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_bet/grand_prix_bet_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../model/driver_details.dart';
import '../../../../model/grand_prix_bet.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../use_case/get_details_for_season_driver_use_case.dart';
import 'grand_prix_bet_cubit.dart';
import 'grand_prix_bet_state.dart';
import 'grand_prix_bet_status_service.dart';

@injectable
class GrandPrixBetRaceBetsService {
  final GrandPrixBetRepository _grandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final GetDetailsForSeasonDriverUseCase _getDetailsForSeasonDriverUseCase;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final GrandPrixBetStatusService _grandPrixBetStatusService;
  final GrandPrixBetCubitParams _params;

  GrandPrixBetRaceBetsService(
    this._grandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._seasonDriverRepository,
    this._getDetailsForSeasonDriverUseCase,
    this._grandPrixBetPointsRepository,
    this._grandPrixBetStatusService,
    @factoryParam this._params,
  );

  Stream<List<SingleDriverBet>> getPodiumBets() {
    return Rx.combineLatest3(
      _getBetPodiumDrivers(),
      _getResultPodiumDrivers(),
      _getPodiumPoints(),
      (
        List<DriverDetails?> betDrivers,
        List<DriverDetails?> resultDrivers,
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
        DriverDetails? betDriver,
        DriverDetails? resultDriver,
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
        DriverDetails? betDriver,
        DriverDetails? resultDriver,
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
        List<DriverDetails?>? betDrivers,
        List<DriverDetails?>? resultDrivers,
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
      _getBet().map((grandPrixBet) => grandPrixBet?.willBeSafetyCar),
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
      _getBet().map((grandPrixBet) => grandPrixBet?.willBeRedFlag),
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

  Stream<List<DriverDetails?>> _getBetPodiumDrivers() {
    return _getBet()
        .map(
          (GrandPrixBet? grandPrixBet) => [
            grandPrixBet?.p1SeasonDriverId,
            grandPrixBet?.p2SeasonDriverId,
            grandPrixBet?.p3SeasonDriverId,
          ],
        )
        .switchMap(_getDetailsForEachSeasonDriver);
  }

  Stream<List<DriverDetails?>> _getResultPodiumDrivers() {
    return _getResults()
        .map(
          (RaceResults? raceResults) => [
            raceResults?.p1SeasonDriverId,
            raceResults?.p2SeasonDriverId,
            raceResults?.p3SeasonDriverId,
          ],
        )
        .switchMap(_getDetailsForEachSeasonDriver);
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

  Stream<DriverDetails?> _getBetP10Driver() {
    return _getBet()
        .map((grandPrixBet) => grandPrixBet?.p10SeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<DriverDetails?> _getResultP10Driver() {
    return _getResults()
        .map((raceResults) => raceResults?.p10SeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<DriverDetails?> _getBetFastestLapDriver() {
    return _getBet()
        .map((grandPrixBet) => grandPrixBet?.fastestLapSeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<DriverDetails?> _getResultFastestLapDriver() {
    return _getResults()
        .map((raceResults) => raceResults?.fastestLapSeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<List<DriverDetails?>?> _getBetDnfDrivers() {
    return _getBet()
        .map((grandPrixBet) => grandPrixBet?.dnfSeasonDriverIds)
        .switchMap(
          (dnfSeasonDriverIds) => dnfSeasonDriverIds != null
              ? _getDetailsForEachSeasonDriver(dnfSeasonDriverIds)
              : Stream.value(null),
        );
  }

  Stream<List<DriverDetails?>?> _getResultDnfDrivers() {
    return _getResults()
        .map((raceResults) => raceResults?.dnfSeasonDriverIds)
        .switchMap(
          (dnfSeasonDriverIds) => dnfSeasonDriverIds != null
              ? _getDetailsForEachSeasonDriver(dnfSeasonDriverIds)
              : Stream.value(null),
        );
  }

  Stream<GrandPrixBet?> _getBet() {
    return _grandPrixBetRepository.getGrandPrixBet(
      playerId: _params.playerId,
      season: _params.season,
      seasonGrandPrixId: _params.seasonGrandPrixId,
    );
  }

  Stream<RaceResults?> _getResults() {
    return _grandPrixResultsRepository
        .getGrandPrixResultsForSeasonGrandPrix(
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map((grandPrixResults) => grandPrixResults?.raceResults);
  }

  Stream<RaceBetPoints?> _getPoints() {
    return _grandPrixBetPointsRepository
        .getGrandPrixBetPointsForPlayerAndSeasonGrandPrix(
          playerId: _params.playerId,
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .map((grandPrixBetPoints) => grandPrixBetPoints?.raceBetPoints);
  }

  Stream<List<DriverDetails?>> _getDetailsForEachSeasonDriver(
    List<String?> seasonDriverIds,
  ) {
    return Rx.combineLatest(
      seasonDriverIds.map(_getDetailsForSeasonDriver),
      (driverDetailsStreams) => driverDetailsStreams,
    );
  }

  Stream<DriverDetails?> _getDetailsForSeasonDriver(String? seasonDriverId) {
    return seasonDriverId != null
        ? _seasonDriverRepository.getSeasonDriverById(seasonDriverId).switchMap(
              (seasonDriver) => seasonDriver != null
                  ? _getDetailsForSeasonDriverUseCase(seasonDriver)
                  : Stream.value(null),
            )
        : Stream.value(null);
  }
}
