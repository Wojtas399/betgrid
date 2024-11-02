import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix/grand_prix_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../dependency_injection.dart';
import '../../../../model/grand_prix.dart';
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
  final DateService _dateService;
  final String _playerId;
  final String _grandPrixId;

  GrandPrixBetCubit(
    this._authRepository,
    this._grandPrixRepository,
    this._playerRepository,
    this._dateService,
    @factoryParam this._playerId,
    @factoryParam this._grandPrixId,
  ) : super(const GrandPrixBetState());

  Future<void> initialize() async {
    final Stream<_ListenedParams> listenedParams$ = _getListenedParams();
    await for (final listenedParams in listenedParams$) {
      final DateTime now = _dateService.getNow();
      final DateTime? gpStartDate = listenedParams.gpListenedParams?.startDate;
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
        isPlayerIdSameAsLoggedUserId: listenedParams.loggedUserId == _playerId,
        qualiBets: listenedParams.qualiBets,
        racePodiumBets: listenedParams.raceListenedParams.podiumBets,
        raceP10Bet: listenedParams.raceListenedParams.p10Bet,
        raceFastestLapBet: listenedParams.raceListenedParams.fastestLapBet,
        raceDnfDriversBet: listenedParams.raceListenedParams.dnfDriversBet,
        raceSafetyCarBet: listenedParams.raceListenedParams.safetyCarBet,
        raceRedFlagBet: listenedParams.raceListenedParams.redFlagBet,
      ));
    }
  }

  Stream<_ListenedParams> _getListenedParams() {
    final qualiBetsService = getIt<GrandPrixBetQualiBetsService>(
      param1: _playerId,
      param2: _grandPrixId,
    );
    return Rx.combineLatest5(
      _getPlayerUsername(),
      _authRepository.loggedUserId$,
      _getGrandPrixListenedParams(),
      qualiBetsService.getQualiBets(),
      _getRaceListenedParams(),
      (
        String? playerUsername,
        String? loggedUserId,
        _GrandPrixListenedParams? gpListenedParams,
        List<SingleDriverBet> qualiBets,
        _RaceListenedParams raceListenedParams,
      ) =>
          _ListenedParams(
        playerUsername: playerUsername,
        loggedUserId: loggedUserId,
        gpListenedParams: gpListenedParams,
        qualiBets: qualiBets,
        raceListenedParams: raceListenedParams,
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
              ? _GrandPrixListenedParams(
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
          _RaceListenedParams(
        podiumBets: podiumBets,
        p10Bet: p10Bet,
        fastestLapBet: fastestLapBet,
        dnfDriversBet: dnfDriversBet,
        safetyCarBet: safetyCarBet,
        redFlagBet: redFlagBet,
      ),
    );
  }
}

class _ListenedParams extends Equatable {
  final String? playerUsername;
  final String? loggedUserId;
  final _GrandPrixListenedParams? gpListenedParams;
  final List<SingleDriverBet> qualiBets;
  final _RaceListenedParams raceListenedParams;

  const _ListenedParams({
    required this.playerUsername,
    required this.loggedUserId,
    required this.gpListenedParams,
    required this.qualiBets,
    required this.raceListenedParams,
  });

  @override
  List<Object?> get props => [
        playerUsername,
        loggedUserId,
        gpListenedParams,
        qualiBets,
        raceListenedParams,
      ];
}

class _RaceListenedParams extends Equatable {
  final List<SingleDriverBet> podiumBets;
  final SingleDriverBet p10Bet;
  final SingleDriverBet fastestLapBet;
  final MultipleDriversBet dnfDriversBet;
  final BooleanBet safetyCarBet;
  final BooleanBet redFlagBet;

  const _RaceListenedParams({
    required this.podiumBets,
    required this.p10Bet,
    required this.fastestLapBet,
    required this.dnfDriversBet,
    required this.safetyCarBet,
    required this.redFlagBet,
  });

  @override
  List<Object?> get props => [
        podiumBets,
        p10Bet,
        fastestLapBet,
        dnfDriversBet,
        safetyCarBet,
        redFlagBet,
      ];
}

class _GrandPrixListenedParams extends Equatable {
  final String name;
  final DateTime startDate;

  const _GrandPrixListenedParams({
    required this.name,
    required this.startDate,
  });

  @override
  List<Object?> get props => [name, startDate];
}
