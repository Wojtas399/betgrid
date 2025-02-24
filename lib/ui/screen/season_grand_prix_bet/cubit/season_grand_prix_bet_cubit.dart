import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/grand_prix_basic_info/grand_prix_basic_info_repository.dart';
import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../model/grand_prix_basic_info.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../service/date_service.dart';
import 'season_grand_prix_bet_state.dart';

@injectable
class SeasonGrandPrixBetCubit extends Cubit<SeasonGrandPrixBetState> {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final GrandPrixBasicInfoRepository _grandPrixBasicInfoRepository;
  final DateService _dateService;
  final int season;
  final String seasonGrandPrixId;
  StreamSubscription<_ListenedParams>? _listener;

  SeasonGrandPrixBetCubit(
    this._seasonGrandPrixRepository,
    this._grandPrixBasicInfoRepository,
    this._dateService,
    @factoryParam this.season,
    @factoryParam this.seasonGrandPrixId,
  ) : super(const SeasonGrandPrixBetState.initial());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  void initialize() async {
    final SeasonGrandPrix? seasonGrandPrix =
        await _seasonGrandPrixRepository
            .getById(season: season, seasonGrandPrixId: seasonGrandPrixId)
            .first;

    if (seasonGrandPrix == null) {
      emit(const SeasonGrandPrixBetState.seasonGrandPrixNotFound());
      return;
    }

    final Duration durationToStart = _dateService.getDurationBetweenDateTimes(
      fromDateTime: _dateService.getNow(),
      toDateTime: seasonGrandPrix.startDate,
    );

    if (durationToStart.isNegative) {
      emit(const SeasonGrandPrixBetState.preview());
      return;
    }

    _listener = _getListenedParams().listen((_ListenedParams params) {
      final Duration durationToStartGp = _dateService
          .getDurationBetweenDateTimes(
            fromDateTime: params.nowDateTime,
            toDateTime: params.seasonGrandPrix.startDateTime,
          );

      if (durationToStartGp.isNegative) {
        emit(const SeasonGrandPrixBetState.preview());
        _listener?.cancel();
      } else {
        emit(
          SeasonGrandPrixBetState.editor(
            roundNumber: params.seasonGrandPrix.roundNumber,
            grandPrixName: params.seasonGrandPrix.grandPrixName,
            durationToStart: durationToStartGp,
          ),
        );
      }
    });
  }

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest2(
      _getSeasonGrandPrixListenedParams(),
      _dateService.getNowStream(),
      (
        _SeasonGrandPrixListenedParams seasonGrandPrixListenedParams,
        DateTime nowDateTime,
      ) => _ListenedParams(
        seasonGrandPrix: seasonGrandPrixListenedParams,
        nowDateTime: nowDateTime,
      ),
    );
  }

  Stream<_SeasonGrandPrixListenedParams> _getSeasonGrandPrixListenedParams() {
    return _seasonGrandPrixRepository
        .getById(season: season, seasonGrandPrixId: seasonGrandPrixId)
        .whereNotNull()
        .switchMap(
          (SeasonGrandPrix seasonGrandPrix) => _grandPrixBasicInfoRepository
              .getGrandPrixBasicInfoById(seasonGrandPrix.grandPrixId)
              .whereNotNull()
              .map(
                (GrandPrixBasicInfo grandPrixBasicInfo) =>
                    _SeasonGrandPrixListenedParams(
                      roundNumber: seasonGrandPrix.roundNumber,
                      grandPrixName: grandPrixBasicInfo.name,
                      startDateTime: seasonGrandPrix.startDate,
                    ),
              ),
        );
  }
}

class _ListenedParams extends Equatable {
  final _SeasonGrandPrixListenedParams seasonGrandPrix;
  final DateTime nowDateTime;

  const _ListenedParams({
    required this.seasonGrandPrix,
    required this.nowDateTime,
  });

  @override
  List<Object?> get props => [seasonGrandPrix, nowDateTime];
}

class _SeasonGrandPrixListenedParams extends Equatable {
  final int roundNumber;
  final String grandPrixName;
  final DateTime startDateTime;

  const _SeasonGrandPrixListenedParams({
    required this.roundNumber,
    required this.grandPrixName,
    required this.startDateTime,
  });

  @override
  List<Object?> get props => [roundNumber, grandPrixName, startDateTime];
}
