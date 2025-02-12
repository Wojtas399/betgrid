import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;
  StreamSubscription<User?>? _loggedUserListener;

  HomeCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const HomeState());

  @override
  Future<void> close() {
    _loggedUserListener?.cancel();
    return super.close();
  }

  void initialize() {
    _loggedUserListener ??= _authRepository.loggedUserId$
        .doOnData(_manageLoggedUserId)
        .whereNotNull()
        .switchMap(_userRepository.getById)
        .listen(_manageLoggedUser);
  }

  void _manageLoggedUserId(String? loggedUserId) {
    if (loggedUserId == null) {
      emit(state.copyWith(
        status: HomeStateStatus.loggedUserDoesNotExist,
      ));
    }
  }

  void _manageLoggedUser(User? loggedUser) {
    if (loggedUser == null) {
      emit(state.copyWith(
        status: HomeStateStatus.loggedUserDataNotCompleted,
      ));
    } else {
      emit(state.copyWith(
        status: HomeStateStatus.completed,
        username: loggedUser.username,
        avatarUrl: loggedUser.avatarUrl,
      ));
    }
  }
}
