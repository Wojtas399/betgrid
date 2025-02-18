import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../common_cubit/season_cubit.dart';
import '../../../service/date_service.dart';
import 'season_grand_prix_bets_gp_status_service.dart';
import 'season_grand_prix_bets_state.dart';

@injectable
class SeasonGrandPrixBetsCubit extends Cubit<SeasonGrandPrixBetsState> {
  final AuthRepository _authRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final GetGrandPrixesWithPointsUseCase _getGrandPrixesWithPointsUseCase;
  final SeasonGrandPrixBetsGpStatusService _gpStatusService;
  final DateService _dateService;
  final SeasonCubit _seasonCubit;
  StreamSubscription<_ListenedData?>? _listener;
  StreamSubscription<Duration?>? _durationToStartNextGpListener;

  SeasonGrandPrixBetsCubit(
    this._authRepository,
    this._getPlayerPointsUseCase,
    this._getGrandPrixesWithPointsUseCase,
    this._gpStatusService,
    this._dateService,
    @factoryParam this._seasonCubit,
  ) : super(const SeasonGrandPrixBetsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    _durationToStartNextGpListener?.cancel();
    return super.close();
  }

  void initialize() {
    _listener ??= _authRepository.loggedUserId$
        .distinct()
        .doOnData((String? loggedUserId) {
          if (loggedUserId == null) {
            emit(
              state.copyWith(
                status: SeasonGrandPrixBetsStateStatus.loggedUserDoesNotExist,
              ),
            );
          }
        })
        .whereNotNull()
        .switchMap(_getListenedData)
        .listen(_manageListenedData);
  }

  Stream<_ListenedData> _getListenedData(String loggedUserId) {
    return Rx.combineLatest2(
      _getPlayerPointsUseCase(
        playerId: loggedUserId,
        season: _seasonCubit.state,
      ),
      _getGrandPrixesWithPointsUseCase(
        playerId: loggedUserId,
        season: _seasonCubit.state,
      ).map(_addStatusForEachGp),
      (double? totalPoints, List<SeasonGrandPrixItemParams> grandPrixItems) =>
          _ListenedData(
            loggedUserId: loggedUserId,
            totalPoints: totalPoints,
            grandPrixItems: grandPrixItems,
          ),
    );
  }

  Future<void> _manageListenedData(_ListenedData data) async {
    if (data.totalPoints == null && data.grandPrixItems.isEmpty) {
      emit(
        state.copyWith(
          status: SeasonGrandPrixBetsStateStatus.noBets,
          loggedUserId: data.loggedUserId,
          season: _seasonCubit.state,
        ),
      );
    } else {
      emit(
        state.copyWith(
          status: SeasonGrandPrixBetsStateStatus.completed,
          loggedUserId: data.loggedUserId,
          season: _seasonCubit.state,
          totalPoints: data.totalPoints,
          grandPrixItems: data.grandPrixItems,
        ),
      );
      _listenToDurationToStartNextGp();
    }
  }

  List<SeasonGrandPrixItemParams> _addStatusForEachGp(
    List<GrandPrixWithPoints> grandPrixesWithPoints,
  ) {
    final now = _dateService.getNow();
    final grandPrixesWithStatus =
        grandPrixesWithPoints
            .map(
              (gp) => SeasonGrandPrixItemParams(
                status: _gpStatusService.defineStatusForGp(
                  gpStartDateTime: gp.startDate,
                  gpEndDateTime: gp.endDate,
                  now: now,
                ),
                seasonGrandPrixId: gp.seasonGrandPrixId,
                grandPrixName: gp.name,
                countryAlpha2Code: gp.countryAlpha2Code,
                roundNumber: gp.roundNumber,
                startDate: gp.startDate,
                endDate: gp.endDate,
                betPoints: gp.points,
              ),
            )
            .toList();
    final sortedGrandPrixesWithStatus = [...grandPrixesWithStatus];
    sortedGrandPrixesWithStatus.sort(
      (gp1, gp2) => gp1.roundNumber.compareTo(gp2.roundNumber),
    );
    final nextGp = sortedGrandPrixesWithStatus.firstWhereOrNull(
      (gp) => gp.status is SeasonGrandPrixStatusUpcoming,
    );
    if (nextGp != null) {
      final nextGpIndex = sortedGrandPrixesWithStatus.indexOf(nextGp);
      sortedGrandPrixesWithStatus[nextGpIndex] = SeasonGrandPrixItemParams(
        status: const SeasonGrandPrixStatusNext(),
        seasonGrandPrixId: nextGp.seasonGrandPrixId,
        grandPrixName: nextGp.grandPrixName,
        countryAlpha2Code: nextGp.countryAlpha2Code,
        roundNumber: nextGp.roundNumber,
        startDate: nextGp.startDate,
        endDate: nextGp.endDate,
        betPoints: nextGp.betPoints,
      );
    }
    return sortedGrandPrixesWithStatus;
  }

  void _listenToDurationToStartNextGp() {
    _durationToStartNextGpListener?.cancel();
    _durationToStartNextGpListener = _dateService
        .getNowStream()
        .map((DateTime now) {
          final nextGp = state.grandPrixItems?.firstWhereOrNull(
            (gp) => gp.status is SeasonGrandPrixStatusNext,
          );
          return nextGp != null
              ? _dateService.getDurationToDateFromNow(nextGp.startDate)
              : null;
        })
        .listen((duration) {
          emit(state.copyWith(durationToStartNextGp: duration));
        });
  }
}

class _ListenedData extends Equatable {
  final String loggedUserId;
  final double? totalPoints;
  final List<SeasonGrandPrixItemParams> grandPrixItems;

  const _ListenedData({
    required this.loggedUserId,
    required this.totalPoints,
    required this.grandPrixItems,
  });

  @override
  List<Object?> get props => [loggedUserId, totalPoints, grandPrixItems];
}
