import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../use_case/get_grand_prixes_with_points_use_case.dart';
import '../../../../use_case/get_player_points_use_case.dart';
import '../../../service/date_service.dart';
import 'bets_state.dart';

@injectable
class BetsCubit extends Cubit<BetsState> {
  final AuthRepository _authRepository;
  final GetPlayerPointsUseCase _getPlayerPointsUseCase;
  final GetGrandPrixesWithPointsUseCase _getGrandPrixesWithPointsUseCase;
  final DateService _dateService;

  BetsCubit(
    this._authRepository,
    this._getPlayerPointsUseCase,
    this._getGrandPrixesWithPointsUseCase,
    this._dateService,
  ) : super(const BetsState());

  Future<void> initialize() async {
    final Stream<String?> loggedUserId$ = _authRepository.loggedUserId$;
    await for (final loggedUserId in loggedUserId$) {
      if (loggedUserId == null) {
        emit(state.copyWith(
          status: BetsStateStatus.loggedUserDoesNotExist,
        ));
      } else {
        await _initializeListenedParams(loggedUserId);
      }
    }
  }

  Future<void> _initializeListenedParams(String loggedUserId) async {
    final int currentYear = _dateService.getNow().year;
    final Stream<_ListenedParams> listenedParams$ = Rx.combineLatest2(
      _getPlayerPointsUseCase(
        playerId: loggedUserId,
        season: currentYear,
      ),
      _getGrandPrixesWithPointsUseCase(
        playerId: loggedUserId,
        season: currentYear,
      ),
      (
        double? totalPoints,
        List<GrandPrixWithPoints> grandPrixesWithPoints,
      ) =>
          _ListenedParams(totalPoints, grandPrixesWithPoints),
    );
    await for (final listenedParams in listenedParams$) {
      emit(state.copyWith(
        status: BetsStateStatus.completed,
        loggedUserId: loggedUserId,
        totalPoints: listenedParams.totalPoints,
        grandPrixesWithPoints: listenedParams.grandPrixesWithPoints,
      ));
    }
  }
}

class _ListenedParams extends Equatable {
  final double? totalPoints;
  final List<GrandPrixWithPoints> grandPrixesWithPoints;

  const _ListenedParams(
    this.totalPoints,
    this.grandPrixesWithPoints,
  );

  @override
  List<Object?> get props => [
        totalPoints,
        grandPrixesWithPoints,
      ];
}
