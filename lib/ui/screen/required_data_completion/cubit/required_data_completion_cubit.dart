import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/exception/user_repository_exception.dart';
import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/player_stats/player_stats_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import '../../../common_cubit/season_cubit.dart';
import 'required_data_completion_state.dart';

@injectable
class RequiredDataCompletionCubit extends Cubit<RequiredDataCompletionState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  final PlayerStatsRepository _playerStatsRepository;
  final SeasonCubit _seasonCubit;

  RequiredDataCompletionCubit(
    this._authRepository,
    this._userRepository,
    this._playerStatsRepository,
    @factoryParam this._seasonCubit,
  ) : super(const RequiredDataCompletionState());

  void updateAvatar(String? newAvatarImgPath) {
    emit(state.copyWith(
      status: RequiredDataCompletionStateStatus.completed,
      avatarImgPath: newAvatarImgPath,
    ));
  }

  void updateUsername(String newUsername) {
    emit(state.copyWith(
      status: RequiredDataCompletionStateStatus.completed,
      username: newUsername,
    ));
  }

  Future<void> submit({
    required ThemeMode themeMode,
    required ThemePrimaryColor themePrimaryColor,
  }) async {
    if (state.username.isEmpty) {
      _emitStatus(RequiredDataCompletionStateStatus.usernameIsEmpty);
      return;
    }
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId == null) return;
    try {
      _emitStatus(RequiredDataCompletionStateStatus.loading);
      await _userRepository.add(
        userId: loggedUserId,
        username: state.username,
        avatarImgPath: state.avatarImgPath,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
      );
      await _playerStatsRepository.addInitialStatsForPlayerAndSeason(
        playerId: loggedUserId,
        season: _seasonCubit.state,
      );
      _emitStatus(RequiredDataCompletionStateStatus.dataSaved);
    } on UserRepositoryExceptionUsernameAlreadyTaken catch (_) {
      _emitStatus(RequiredDataCompletionStateStatus.usernameIsAlreadyTaken);
    }
  }

  _emitStatus(RequiredDataCompletionStateStatus status) {
    emit(state.copyWith(
      status: status,
    ));
  }
}
