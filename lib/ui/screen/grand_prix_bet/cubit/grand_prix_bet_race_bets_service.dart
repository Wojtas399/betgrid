import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/season_grand_prix_bet/season_grand_prix_bet_repository.dart';
import '../../../../data/repository/seasongrand_prix_bet_points/season_grand_prix_bet_points_repository.dart';
import '../../../../data/repository/grand_prix_result/grand_prix_results_repository.dart';
import '../../../../data/repository/season_driver/season_driver_repository.dart';
import '../../../../model/driver_details.dart';
import '../../../../model/season_grand_prix_bet.dart';
import '../../../../model/season_grand_prix_bet_points.dart';
import '../../../../model/grand_prix_results.dart';
import '../../../../use_case/get_details_for_season_driver_use_case.dart';
import 'grand_prix_bet_cubit.dart';
import 'grand_prix_bet_state.dart';
import 'grand_prix_bet_status_service.dart';

@injectable
class GrandPrixBetRaceBetsService {
  final SeasonGrandPrixBetRepository _seasonGrandPrixBetRepository;
  final GrandPrixResultsRepository _grandPrixResultsRepository;
  final SeasonDriverRepository _seasonDriverRepository;
  final GetDetailsForSeasonDriverUseCase _getDetailsForSeasonDriverUseCase;
  final SeasonGrandPrixBetPointsRepository _seasonGrandPrixBetPointsRepository;
  final GrandPrixBetStatusService _grandPrixBetStatusService;
  final GrandPrixBetCubitParams _params;

  GrandPrixBetRaceBetsService(
    this._seasonGrandPrixBetRepository,
    this._grandPrixResultsRepository,
    this._seasonDriverRepository,
    this._getDetailsForSeasonDriverUseCase,
    this._seasonGrandPrixBetPointsRepository,
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
      _getPoints().map((points) => points?.p10),
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
      _getPoints().map((points) => points?.fastestLap),
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
      _getPoints().map((points) => points?.totalDnf),
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
      _getSeasonGrandPrixBet().map(
        (seasonGrandPrixBet) => seasonGrandPrixBet?.willBeSafetyCar,
      ),
      _getResults().map((raceResults) => raceResults?.wasThereSafetyCar),
      _getPoints().map((points) => points?.safetyCar),
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
      _getSeasonGrandPrixBet().map(
        (seasonGrandPrixBet) => seasonGrandPrixBet?.willBeRedFlag,
      ),
      _getResults().map((raceResults) => raceResults?.wasThereRedFlag),
      _getPoints().map((points) => points?.redFlag),
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
    return _getSeasonGrandPrixBet()
        .map(
          (SeasonGrandPrixBet? seasonGrandPrixBet) => [
            seasonGrandPrixBet?.p1SeasonDriverId,
            seasonGrandPrixBet?.p2SeasonDriverId,
            seasonGrandPrixBet?.p3SeasonDriverId,
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
        points?.p1,
        points?.p2,
        points?.p3,
      ],
    );
  }

  Stream<DriverDetails?> _getBetP10Driver() {
    return _getSeasonGrandPrixBet()
        .map((seasonGrandPrixBet) => seasonGrandPrixBet?.p10SeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<DriverDetails?> _getResultP10Driver() {
    return _getResults()
        .map((raceResults) => raceResults?.p10SeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<DriverDetails?> _getBetFastestLapDriver() {
    return _getSeasonGrandPrixBet()
        .map(
          (seasonGrandPrixBet) => seasonGrandPrixBet?.fastestLapSeasonDriverId,
        )
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<DriverDetails?> _getResultFastestLapDriver() {
    return _getResults()
        .map((raceResults) => raceResults?.fastestLapSeasonDriverId)
        .switchMap(_getDetailsForSeasonDriver);
  }

  Stream<List<DriverDetails?>?> _getBetDnfDrivers() {
    return _getSeasonGrandPrixBet()
        .map((seasonGrandPrixBet) => seasonGrandPrixBet?.dnfSeasonDriverIds)
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

  Stream<SeasonGrandPrixBet?> _getSeasonGrandPrixBet() {
    return _seasonGrandPrixBetRepository.getSeasonGrandPrixBet(
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
    return _seasonGrandPrixBetPointsRepository
        .getSeasonGrandPrixBetPoints(
          playerId: _params.playerId,
          season: _params.season,
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
