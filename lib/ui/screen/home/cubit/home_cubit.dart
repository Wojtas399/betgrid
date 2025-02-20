import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player_stats/player_stats_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/player_stats.dart';
import '../../../../model/user.dart';
import '../../../common_cubit/season_cubit.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final PlayerStatsRepository _playerStatsRepository;
  final SeasonCubit _seasonCubit;
  StreamSubscription<_ListenedData>? _dataListener;

  HomeCubit(
    this._authRepository,
    this._userRepository,
    this._playerStatsRepository,
    @factoryParam this._seasonCubit,
  ) : super(const HomeState());

  @override
  Future<void> close() {
    _dataListener?.cancel();
    return super.close();
  }

  void initialize() {
    _dataListener ??= _authRepository.loggedUserId$
        .doOnData(_manageLoggedUserId)
        .whereNotNull()
        .switchMap(_getListenedData)
        .listen(_manageListenedData);
  }

  void _manageLoggedUserId(String? loggedUserId) {
    if (loggedUserId == null) {
      emit(state.copyWith(status: HomeStateStatus.loggedUserDoesNotExist));
    }
  }

  Stream<_ListenedData> _getListenedData(String loggedUserId) {
    return Rx.combineLatest2(
      _userRepository.getById(loggedUserId),
      _playerStatsRepository.getByPlayerIdAndSeason(
        playerId: loggedUserId,
        season: _seasonCubit.state,
      ),
      (User? user, PlayerStats? stats) =>
          _ListenedData(loggedUserData: user, totalPoints: stats?.totalPoints),
    );
  }

  void _manageListenedData(_ListenedData data) {
    final User? loggedUser = data.loggedUserData;
    final double? totalPoints = data.totalPoints;

    if (loggedUser == null || totalPoints == null) {
      emit(state.copyWith(status: HomeStateStatus.loggedUserDataNotCompleted));
    } else {
      emit(
        state.copyWith(
          status: HomeStateStatus.completed,
          username: loggedUser.username,
          avatarUrl: loggedUser.avatarUrl,
          totalPoints: totalPoints,
        ),
      );
    }
  }
}

class _ListenedData with EquatableMixin {
  final User? loggedUserData;
  final double? totalPoints;

  _ListenedData({required this.loggedUserData, required this.totalPoints});

  @override
  List<Object?> get props => [loggedUserData, totalPoints];
}
