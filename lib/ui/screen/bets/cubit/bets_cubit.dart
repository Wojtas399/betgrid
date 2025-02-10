import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../service/date_service.dart';
import 'bets_gp_status_service.dart';
import 'bets_state.dart';

@injectable
class BetsCubit extends Cubit<BetsState> {
  final AuthRepository _authRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final GetGrandPrixesWithPointsUseCase _getGrandPrixesWithPointsUseCase;
  final BetsGpStatusService _gpStatusService;
  final DateService _dateService;
  StreamSubscription<_ListenedData?>? _listener;
  StreamSubscription<Duration?>? _durationToStartNextGpListener;

  BetsCubit(
    this._authRepository,
    this._getPlayerPointsUseCase,
    this._getGrandPrixesWithPointsUseCase,
    this._gpStatusService,
    this._dateService,
  ) : super(const BetsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    _durationToStartNextGpListener?.cancel();
    return super.close();
  }

  void initialize() {
    final int currentSeason = _dateService.getNow().year;
    _listener ??= _authRepository.loggedUserId$
        .distinct()
        .doOnData(
          (String? loggedUserId) {
            if (loggedUserId == null) {
              emit(state.copyWith(
                status: BetsStateStatus.loggedUserDoesNotExist,
              ));
            }
          },
        )
        .whereNotNull()
        .switchMap(
          (String loggedUserId) =>
              _getListenedData(loggedUserId, currentSeason),
        )
        .listen(
          (_ListenedData data) => _manageListenedData(data, currentSeason),
        );
  }

  Stream<_ListenedData> _getListenedData(
    String loggedUserId,
    int season,
  ) {
    return Rx.combineLatest2(
      _getPlayerPointsUseCase(
        playerId: loggedUserId,
        season: season,
      ),
      _getGrandPrixesWithPointsUseCase(
        playerId: loggedUserId,
        season: season,
      ).map(_addStatusForEachGp),
      (
        double? totalPoints,
        List<GrandPrixItemParams> grandPrixItems,
      ) =>
          _ListenedData(
        loggedUserId: loggedUserId,
        totalPoints: totalPoints,
        grandPrixItems: grandPrixItems,
      ),
    );
  }

  Future<void> _manageListenedData(_ListenedData data, int season) async {
    if (data.totalPoints == null && data.grandPrixItems.isEmpty) {
      emit(state.copyWith(
        status: BetsStateStatus.noBets,
        loggedUserId: data.loggedUserId,
        season: season,
      ));
    } else {
      emit(state.copyWith(
        status: BetsStateStatus.completed,
        loggedUserId: data.loggedUserId,
        season: season,
        totalPoints: data.totalPoints,
        grandPrixItems: data.grandPrixItems,
      ));
      _listenToDurationToStartNextGp();
    }
  }

  List<GrandPrixItemParams> _addStatusForEachGp(
    List<GrandPrixWithPoints> grandPrixesWithPoints,
  ) {
    final now = _dateService.getNow();
    final grandPrixesWithStatus = grandPrixesWithPoints
        .map(
          (gp) => GrandPrixItemParams(
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
      (gp) => gp.status is GrandPrixStatusUpcoming,
    );
    if (nextGp != null) {
      final nextGpIndex = sortedGrandPrixesWithStatus.indexOf(nextGp);
      sortedGrandPrixesWithStatus[nextGpIndex] = GrandPrixItemParams(
        status: const GrandPrixStatusNext(),
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
    _durationToStartNextGpListener = _dateService.getNowStream().map(
      (DateTime now) {
        final nextGp = state.grandPrixItems?.firstWhereOrNull(
          (gp) => gp.status is GrandPrixStatusNext,
        );
        return nextGp != null
            ? _dateService.getDurationToDateFromNow(nextGp.startDate)
            : null;
      },
    ).listen(
      (duration) {
        emit(state.copyWith(
          durationToStartNextGp: duration,
        ));
      },
    );
  }
}

class _ListenedData extends Equatable {
  final String loggedUserId;
  final double? totalPoints;
  final List<GrandPrixItemParams> grandPrixItems;

  const _ListenedData({
    required this.loggedUserId,
    required this.totalPoints,
    required this.grandPrixItems,
  });

  @override
  List<Object?> get props => [
        loggedUserId,
        totalPoints,
        grandPrixItems,
      ];
}
