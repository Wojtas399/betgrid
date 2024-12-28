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
    return super.close();
  }

  void initialize() {
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
        .switchMap(_getListenedData)
        .listen(_manageListenedData);
  }

  Stream<_ListenedData> _getListenedData(String loggedUserId) {
    const int currentYear = 2025;
    return Rx.combineLatest2(
      _getPlayerPointsUseCase(
        playerId: loggedUserId,
        season: currentYear,
      ),
      _getGrandPrixItems(loggedUserId, currentYear),
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

  Future<void> _manageListenedData(_ListenedData data) async {
    if (data.totalPoints == null && data.grandPrixItems.isEmpty) {
      emit(state.copyWith(
        status: BetsStateStatus.noBets,
        loggedUserId: data.loggedUserId,
      ));
    } else {
      emit(state.copyWith(
        status: BetsStateStatus.completed,
        loggedUserId: data.loggedUserId,
        totalPoints: data.totalPoints,
        grandPrixItems: data.grandPrixItems,
      ));
    }
  }

  Stream<List<GrandPrixItemParams>> _getGrandPrixItems(
    String playerId,
    int season,
  ) {
    return Rx.combineLatest2(
      _getGrandPrixesWithPointsUseCase(
        playerId: playerId,
        season: season,
      ),
      _dateService.getNowStream(),
      (grandPrixesWithPoints, now) => (
        grandPrixesWithPoints: grandPrixesWithPoints,
        now: now,
      ),
    ).map((data) => _addStatusForEachGp(data.grandPrixesWithPoints, data.now));
  }

  List<GrandPrixItemParams> _addStatusForEachGp(
    List<GrandPrixWithPoints> grandPrixesWithPoints,
    DateTime now,
  ) {
    final grandPrixesWithStatus = grandPrixesWithPoints
        .map((gp) => GrandPrixItemParams(
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
            ))
        .toList();
    final int? ongoingGpRoundNumber = grandPrixesWithStatus
        .firstWhereOrNull((gp) => gp.status is GrandPrixStatusOngoing)
        ?.roundNumber;
    final int nextGpRoundNumber = (ongoingGpRoundNumber ?? 0) + 1;
    final int nextGpIndex = grandPrixesWithStatus.indexWhere(
      (gp) => gp.roundNumber == nextGpRoundNumber,
    );
    if (nextGpIndex > -1) {
      final nextGp = grandPrixesWithStatus[nextGpIndex];
      grandPrixesWithStatus[nextGpIndex] = GrandPrixItemParams(
        status: GrandPrixStatusNext(
          durationToStart: _dateService.getDurationToDateFromNow(
            nextGp.startDate,
          ),
        ),
        seasonGrandPrixId: nextGp.seasonGrandPrixId,
        grandPrixName: nextGp.grandPrixName,
        countryAlpha2Code: nextGp.countryAlpha2Code,
        roundNumber: nextGp.roundNumber,
        startDate: nextGp.startDate,
        endDate: nextGp.endDate,
        betPoints: nextGp.betPoints,
      );
    }
    return grandPrixesWithStatus;
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
