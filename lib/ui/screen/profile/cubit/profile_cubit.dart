import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/exception/user_repository_exception.dart';
import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<User?>? _loggedUserDataListener;

  ProfileCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const ProfileState());

  @override
  Future<void> close() {
    _loggedUserDataListener?.cancel();
    return super.close();
  }

  void initialize() {
    _loggedUserDataListener ??= _authRepository.loggedUserId$
        .whereNotNull()
        .switchMap(_userRepository.getById)
        .listen(
      (User? loggedUser) {
        emit(state.copyWith(
          status: ProfileStateStatus.completed,
          username: loggedUser?.username,
          avatarUrl: loggedUser?.avatarUrl,
          themeMode: loggedUser?.themeMode,
          themePrimaryColor: loggedUser?.themePrimaryColor,
        ));
      },
    );
  }

  Future<void> updateAvatar(String? newAvatarImgPath) async {
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId != null) {
      emit(state.copyWith(
        status: ProfileStateStatus.loading,
      ));
      await _userRepository.updateAvatar(
        userId: loggedUserId,
        avatarImgPath: newAvatarImgPath,
      );
      emit(state.copyWith(
        status: ProfileStateStatus.completed,
      ));
    }
  }

  Future<void> updateUsername(String newUsername) async {
    if (newUsername.isEmpty) return;
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId == null) return;
    try {
      emit(state.copyWith(
        status: ProfileStateStatus.loading,
      ));
      await _userRepository.updateData(
        userId: loggedUserId,
        username: newUsername,
      );
      emit(state.copyWith(
        status: ProfileStateStatus.usernameUpdated,
      ));
    } on UserRepositoryExceptionUsernameAlreadyTaken catch (_) {
      emit(state.copyWith(
        status: ProfileStateStatus.newUsernameIsAlreadyTaken,
      ));
    }
  }
}
