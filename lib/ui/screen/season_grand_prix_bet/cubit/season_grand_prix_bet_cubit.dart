import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../data/repository/player/player_repository.dart';
import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../../model/player.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../service/date_service.dart';
import 'season_grand_prix_bet_state.dart';

class SeasonGrandPrixBetCubitParams {
  final int season;
  final String seasonGrandPrixId;
  final String? playerId;

  const SeasonGrandPrixBetCubitParams({
    required this.season,
    required this.seasonGrandPrixId,
    this.playerId,
  });
}

@injectable
class SeasonGrandPrixBetCubit extends Cubit<SeasonGrandPrixBetState> {
  final AuthRepository _authRepository;
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final DateService _dateService;
  final PlayerRepository _playerRepository;
  final SeasonGrandPrixBetCubitParams _params;
  StreamSubscription<_ListenedParams>? _listener;

  SeasonGrandPrixBetCubit(
    this._authRepository,
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._dateService,
    this._playerRepository,
    @factoryParam this._params,
  ) : super(const SeasonGrandPrixBetState.initial());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    final SeasonGrandPrix? seasonGrandPrix = await _getSeasonGrandPrix().first;

    if (seasonGrandPrix == null) {
      emit(const SeasonGrandPrixBetState.seasonGrandPrixNotFound());
      return;
    }

    final Duration durationToStart = _dateService.getDurationBetweenDateTimes(
      fromDateTime: _dateService.getNow(),
      toDateTime: seasonGrandPrix.startDate,
    );

    if (durationToStart.isNegative || _params.playerId != null) {
      await _initializePreviewState(seasonGrandPrix.grandPrixId);
    } else {
      _initializeEditorState();
    }
  }

  void onSaveStarted() {
    emit((state as SeasonGrandPrixBetStateEditor).copyWith(isSaving: true));
  }

  void onSaveFinished() {
    emit((state as SeasonGrandPrixBetStateEditor).copyWith(isSaving: false));
  }

  Stream<SeasonGrandPrix?> _getSeasonGrandPrix() {
    return _seasonGrandPrixRepository.getById(
      season: _params.season,
      seasonGrandPrixId: _params.seasonGrandPrixId,
    );
  }

  Future<void> _initializePreviewState(String grandPrixId) async {
    final String? grandPrixName = await _getGrandPrixName(grandPrixId).first;
    final String? playerId =
        _params.playerId ?? await _authRepository.loggedUserId$.first;
    final String? playerUsername =
        _params.playerId != null ? await _getPlayerUsername().first : null;

    emit(
      SeasonGrandPrixBetState.preview(
        season: _params.season,
        seasonGrandPrixId: _params.seasonGrandPrixId,
        grandPrixName: grandPrixName!,
        playerId: playerId!,
        playerUsername: playerUsername,
      ),
    );
  }

  void _initializeEditorState() {
    _listener = _getListenedParams().listen((_ListenedParams params) async {
      final SeasonGrandPrixBetState currentState = state;
      final _SeasonGrandPrixInfo seasonGrandPrix = params.seasonGrandPrix!;
      final String? loggedUserId = await _authRepository.loggedUserId$.first;
      final Duration durationToStartGp = _dateService
          .getDurationBetweenDateTimes(
            fromDateTime: params.nowDateTime,
            toDateTime: seasonGrandPrix.startDateTime,
          );

      if (durationToStartGp.isNegative &&
          (currentState as SeasonGrandPrixBetStateEditor).isSaving == false) {
        emit(
          SeasonGrandPrixBetState.preview(
            season: _params.season,
            seasonGrandPrixId: _params.seasonGrandPrixId,
            grandPrixName: seasonGrandPrix.grandPrixName,
            playerId: loggedUserId!,
          ),
        );
        _listener?.cancel();
      } else {
        emit(
          currentState is SeasonGrandPrixBetStateEditor
              ? currentState.copyWith(
                durationToStart:
                    durationToStartGp.isNegative
                        ? Duration.zero
                        : durationToStartGp,
              )
              : SeasonGrandPrixBetState.editor(
                season: _params.season,
                seasonGrandPrixId: _params.seasonGrandPrixId,
                roundNumber: seasonGrandPrix.roundNumber,
                grandPrixName: seasonGrandPrix.grandPrixName,
                durationToStart: durationToStartGp,
              ),
        );
      }
    });
  }

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest3(
      _getSeasonGrandPrixInfo(),
      _dateService.getNowStream(),
      _getPlayerUsername(),
      (
        _SeasonGrandPrixInfo? seasonGrandPrixInfo,
        DateTime nowDateTime,
        String? playerUsername,
      ) => _ListenedParams(
        seasonGrandPrix: seasonGrandPrixInfo,
        nowDateTime: nowDateTime,
        playerUsername: playerUsername,
      ),
    );
  }

  Stream<_SeasonGrandPrixInfo?> _getSeasonGrandPrixInfo() {
    return _seasonGrandPrixRepository
        .getById(
          season: _params.season,
          seasonGrandPrixId: _params.seasonGrandPrixId,
        )
        .switchMap(
          (SeasonGrandPrix? seasonGrandPrix) =>
              seasonGrandPrix == null
                  ? Stream.value(null)
                  : _getGrandPrixName(seasonGrandPrix.grandPrixId).map(
                    (String? grandPrixName) =>
                        grandPrixName == null
                            ? null
                            : _SeasonGrandPrixInfo(
                              roundNumber: seasonGrandPrix.roundNumber,
                              grandPrixName: grandPrixName,
                              startDateTime: seasonGrandPrix.startDate,
                            ),
                  ),
        );
  }

  Stream<String?> _getGrandPrixName(String grandPrixId) {
    return _grandPrixBasicInfoRepository
        .getById(grandPrixId)
        .map((GrandPrixBasicInfo? basicInfo) => basicInfo?.name);
  }

  Stream<String?> _getPlayerUsername() {
    return _params.playerId != null
        ? _playerRepository
            .getById(_params.playerId!)
            .map((Player? player) => player?.username)
        : Stream.value(null);
  }
}

class _ListenedParams extends Equatable {
  final _SeasonGrandPrixInfo? seasonGrandPrix;
  final DateTime nowDateTime;
  final String? playerUsername;

  const _ListenedParams({
    required this.seasonGrandPrix,
    required this.nowDateTime,
    this.playerUsername,
  });

  @override
  List<Object?> get props => [seasonGrandPrix, nowDateTime, playerUsername];
}

class _SeasonGrandPrixInfo extends Equatable {
  final int roundNumber;
  final String grandPrixName;
  final DateTime startDateTime;

  const _SeasonGrandPrixInfo({
    required this.roundNumber,
    required this.grandPrixName,
    required this.startDateTime,
  });

  @override
  List<Object?> get props => [roundNumber, grandPrixName, startDateTime];
}
