import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/exception/user_repository_exception.dart';
import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import 'required_data_completion_state.dart';

@injectable
class RequiredDataCompletionCubit extends Cubit<RequiredDataCompletionState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  RequiredDataCompletionCubit(
    this._authRepository,
    this._userRepository,
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
    if (loggedUserId == null) {
      _emitStatus(RequiredDataCompletionStateStatus.loggedUserDoesNotExist);
      return;
    }
    try {
      _emitStatus(RequiredDataCompletionStateStatus.loading);
      await _userRepository.addUser(
        userId: loggedUserId,
        username: state.username,
        avatarImgPath: state.avatarImgPath,
        themeMode: themeMode,
        themePrimaryColor: themePrimaryColor,
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
