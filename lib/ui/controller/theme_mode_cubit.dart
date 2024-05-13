import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repository/auth/auth_repository.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

@injectable
class ThemeModeCubit extends Cubit<ThemeMode> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  ThemeModeCubit(
    this._authRepository,
    this._userRepository,
  ) : super(ThemeMode.system);

  Future<void> initialize() async {
    final Stream<User?> loggedUser$ = _getLoggedUser();
    await for (final loggedUser in loggedUser$) {
      if (loggedUser != null) {
        emit(loggedUser.themeMode);
      }
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    final ThemeMode prevThemeMode = state;
    emit(themeMode);
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId != null) {
      try {
        await _userRepository.updateUserData(
          userId: loggedUserId,
          themeMode: themeMode,
        );
      } catch (_) {
        emit(prevThemeMode);
      }
    } else {
      emit(prevThemeMode);
    }
  }

  Stream<User?> _getLoggedUser() => _authRepository.loggedUserId$.switchMap(
        (String? loggedUserId) => loggedUserId != null
            ? _userRepository.getUserById(userId: loggedUserId)
            : Stream.value(null),
      );
}
