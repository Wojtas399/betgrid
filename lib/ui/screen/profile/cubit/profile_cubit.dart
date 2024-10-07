import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/exception/user_repository_exception.dart';
import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import 'profile_state.dart';

@injectable
class ProfileCubit extends Cubit<ProfileState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  ProfileCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const ProfileState());

  Future<void> initialize() async {
    final Stream<String?> loggedUserId$ = _authRepository.loggedUserId$;
    await for (final loggedUserId in loggedUserId$) {
      if (loggedUserId != null) {
        await _initializeLoggedUserData(loggedUserId);
      }
    }
  }

  Future<void> updateAvatar(String? newAvatarImgPath) async {
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId != null) {
      emit(state.copyWith(
        status: ProfileStateStatus.loading,
      ));
      await _userRepository.updateUserAvatar(
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
      await _userRepository.updateUserData(
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

  Future<void> _initializeLoggedUserData(String loggedUserId) async {
    final Stream<User?> loggedUser$ = _userRepository.getUserById(
      userId: loggedUserId,
    );
    await for (final loggedUser in loggedUser$) {
      emit(state.copyWith(
        status: ProfileStateStatus.completed,
        username: loggedUser?.username,
        avatarUrl: loggedUser?.avatarUrl,
        themeMode: loggedUser?.themeMode,
        themePrimaryColor: loggedUser?.themePrimaryColor,
      ));
    }
  }
}
