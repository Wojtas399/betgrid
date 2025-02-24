import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/season_grand_prix/season_grand_prix_repository.dart';
import '../../../../model/season_grand_prix.dart';
import '../../../service/date_service.dart';
import 'season_grand_prix_bet_state.dart';

@injectable
class SeasonGrandPrixBetCubit extends Cubit<SeasonGrandPrixBetState> {
  final SeasonGrandPrixRepository _seasonGrandPrixRepository;
  final DateService _dateService;
  final int season;
  final String seasonGrandPrixId;
  StreamSubscription<_ListenedParams>? _listener;

  SeasonGrandPrixBetCubit(
    this._seasonGrandPrixRepository,
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
    _listener = _getListenedParams().listen((_ListenedParams params) {
      if (params.seasonGrandPrix == null) {
        emit(const SeasonGrandPrixBetState.seasonGrandPrixNotFound());
        return;
      }

      final Duration durationToStartGp = _dateService
          .getDurationBetweenDateTimes(
            fromDateTime: params.nowDateTime,
            toDateTime: params.seasonGrandPrix!.startDate,
          );

      if (durationToStartGp.isNegative) {
        emit(const SeasonGrandPrixBetState.preview());
      } else {
        emit(const SeasonGrandPrixBetState.editor());
      }
    });
  }

  Stream<_ListenedParams> _getListenedParams() {
    return Rx.combineLatest2(
      _seasonGrandPrixRepository.getById(
        season: season,
        seasonGrandPrixId: seasonGrandPrixId,
      ),
      _dateService.getNowStream(),
      (SeasonGrandPrix? seasonGrandPrix, DateTime nowDateTime) =>
          _ListenedParams(
            seasonGrandPrix: seasonGrandPrix,
            nowDateTime: nowDateTime,
          ),
    );
  }
}

class _ListenedParams extends Equatable {
  final SeasonGrandPrix? seasonGrandPrix;
  final DateTime nowDateTime;

  const _ListenedParams({
    required this.seasonGrandPrix,
    required this.nowDateTime,
  });

  @override
  List<Object?> get props => [seasonGrandPrix, nowDateTime];
}
