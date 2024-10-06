import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repository/auth/auth_repository.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';
import 'theme_state.dart';

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  ThemeCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const ThemeState());

  Future<void> initialize() async {
    final Stream<User?> loggedUser$ = _getLoggedUser();
    await for (final loggedUser in loggedUser$) {
      if (loggedUser != null) {
        emit(ThemeState(
          themeMode: loggedUser.themeMode,
          primaryColor: loggedUser.themePrimaryColor,
        ));
      } else {
        emit(const ThemeState());
      }
    }
  }

  Future<void> changeThemeMode(ThemeMode themeMode) async {
    final ThemeState prevState = state;
    emit(state.copyWith(
      themeMode: themeMode,
    ));
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId != null) {
      try {
        await _userRepository.updateUserData(
          userId: loggedUserId,
          themeMode: themeMode,
        );
      } catch (_) {
        emit(prevState);
      }
    } else {
      emit(prevState);
    }
  }

  Future<void> changePrimaryColor(ThemePrimaryColor primaryColor) async {
    final ThemeState prevState = state;
    emit(state.copyWith(
      primaryColor: primaryColor,
    ));
    final String? loggedUserId = await _authRepository.loggedUserId$.first;
    if (loggedUserId != null) {
      try {
        await _userRepository.updateUserData(
          userId: loggedUserId,
          themePrimaryColor: primaryColor,
        );
      } catch (_) {
        emit(prevState);
      }
    } else {
      emit(prevState);
    }
  }

  Stream<User?> _getLoggedUser() => _authRepository.loggedUserId$.switchMap(
        (String? loggedUserId) => loggedUserId != null
            ? _userRepository.getUserById(userId: loggedUserId)
            : Stream.value(null),
      );
}
