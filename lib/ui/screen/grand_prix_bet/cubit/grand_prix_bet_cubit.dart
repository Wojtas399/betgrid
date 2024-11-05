import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/grand_prix_bet_points/grand_prix_bet_points_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix.dart';
import '../../../../model/grand_prix_bet_points.dart';
import '../../../../model/player.dart';
import '../../../service/date_service.dart';
import 'grand_prix_bet_quali_bets_service.dart';
import 'grand_prix_bet_race_bets_service.dart';
import 'grand_prix_bet_state.dart';

@injectable
class GrandPrixBetCubit extends Cubit<GrandPrixBetState> {
  final AuthRepository _authRepository;
  final GrandPrixRepository _grandPrixRepository;
  final PlayerRepository _playerRepository;
  final GrandPrixBetPointsRepository _grandPrixBetPointsRepository;
  final DateService _dateService;
  final String _playerId;
  final String _grandPrixId;
  StreamSubscription<_ListenedParams>? _listenedParamsListener;

  GrandPrixBetCubit(
    this._authRepository,
    this._grandPrixRepository,
    this._playerRepository,
    this._grandPrixBetPointsRepository,
    this._dateService,
    @factoryParam this._playerId,
    @factoryParam this._grandPrixId,
  ) : super(const GrandPrixBetState());

  @override
  Future<void> close() {
    _listenedParamsListener?.cancel();
    return super.close();
  }

  void initialize() {
    _listenedParamsListener ??= _getListenedParams().distinct().listen(
      (_ListenedParams listenedParams) {
        final DateTime now = _dateService.getNow();
        final DateTime? gpStartDate =
            listenedParams.gpListenedParams?.startDate;
        bool? canEdit;
        if (gpStartDate != null) {
          canEdit = _dateService.isDateABeforeDateB(now, gpStartDate);
        }
        emit(state.copyWith(
          status: GrandPrixBetStateStatus.completed,
          canEdit: canEdit,
          playerUsername: listenedParams.playerUsername,
          grandPrixId: _grandPrixId,
          grandPrixName: listenedParams.gpListenedParams?.name,
          isPlayerIdSameAsLoggedUserId:
              listenedParams.loggedUserId == _playerId,
          qualiBets: listenedParams.qualiBets,
          racePodiumBets: listenedParams.raceListenedParams.podiumBets,
          raceP10Bet: listenedParams.raceListenedParams.p10Bet,
          raceFastestLapBet: listenedParams.raceListenedParams.fastestLapBet,
          raceDnfDriversBet: listenedParams.raceListenedParams.dnfDriversBet,
          raceSafetyCarBet: listenedParams.raceListenedParams.safetyCarBet,
          raceRedFlagBet: listenedParams.raceListenedParams.redFlagBet,
          grandPrixBetPoints: listenedParams.gpBetPoints,
        ));
      },
    );
  }

  Stream<_ListenedParams> _getListenedParams() {
    final qualiBetsService = getIt<GrandPrixBetQualiBetsService>(
      param1: _playerId,
      param2: _grandPrixId,
    );
    return Rx.combineLatest6(
      _getPlayerUsername(),
      _authRepository.loggedUserId$,
      _getGrandPrixListenedParams(),
      qualiBetsService.getQualiBets(),
      _getRaceListenedParams(),
      _getGpBetPoints(),
      (
        String? playerUsername,
        String? loggedUserId,
        _GrandPrixListenedParams? gpListenedParams,
        List<SingleDriverBet> qualiBets,
        _RaceListenedParams raceListenedParams,
        GrandPrixBetPoints? gpBetPoints,
      ) =>
          (
        playerUsername: playerUsername,
        loggedUserId: loggedUserId,
        gpListenedParams: gpListenedParams,
        qualiBets: qualiBets,
        raceListenedParams: raceListenedParams,
        gpBetPoints: gpBetPoints,
      ),
    );
  }

  Stream<String?> _getPlayerUsername() {
    return _playerRepository
        .getPlayerById(playerId: _playerId)
        .map((Player? player) => player?.username);
  }

  Stream<_GrandPrixListenedParams?> _getGrandPrixListenedParams() {
    return _grandPrixRepository.getGrandPrixById(grandPrixId: _grandPrixId).map(
          (GrandPrix? grandPrix) => grandPrix != null
              ? (
                  name: grandPrix.name,
                  startDate: grandPrix.startDate,
                )
              : null,
        );
  }

  Stream<_RaceListenedParams> _getRaceListenedParams() {
    final raceBetsService = getIt<GrandPrixBetRaceBetsService>(
      param1: _playerId,
      param2: _grandPrixId,
    );
    return Rx.combineLatest6(
      raceBetsService.getPodiumBets(),
      raceBetsService.getP10Bet(),
      raceBetsService.getFastestLapBet(),
      raceBetsService.getDnfDriversBet(),
      raceBetsService.getSafetyCarBet(),
      raceBetsService.getRedFlagBet(),
      (
        List<SingleDriverBet> podiumBets,
        SingleDriverBet p10Bet,
        SingleDriverBet fastestLapBet,
        MultipleDriversBet dnfDriversBet,
        BooleanBet safetyCarBet,
        BooleanBet redFlagBet,
      ) =>
          (
        podiumBets: podiumBets,
        p10Bet: p10Bet,
        fastestLapBet: fastestLapBet,
        dnfDriversBet: dnfDriversBet,
        safetyCarBet: safetyCarBet,
        redFlagBet: redFlagBet,
      ),
    );
  }

  Stream<GrandPrixBetPoints?> _getGpBetPoints() {
    return _grandPrixBetPointsRepository
        .getGrandPrixBetPointsForPlayerAndGrandPrix(
      playerId: _playerId,
      grandPrixId: _grandPrixId,
    );
  }
}

typedef _ListenedParams = ({
  String? playerUsername,
  String? loggedUserId,
  _GrandPrixListenedParams? gpListenedParams,
  List<SingleDriverBet> qualiBets,
  _RaceListenedParams raceListenedParams,
  GrandPrixBetPoints? gpBetPoints,
});

typedef _RaceListenedParams = ({
  List<SingleDriverBet> podiumBets,
  SingleDriverBet p10Bet,
  SingleDriverBet fastestLapBet,
  MultipleDriversBet dnfDriversBet,
  BooleanBet safetyCarBet,
  BooleanBet redFlagBet,
});

typedef _GrandPrixListenedParams = ({
  String name,
  DateTime startDate,
});
