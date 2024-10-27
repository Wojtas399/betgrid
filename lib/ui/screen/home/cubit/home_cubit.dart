import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../data/repository/user/user_repository.dart';
import '../../../../model/user.dart';
import 'home_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  HomeCubit(
    this._authRepository,
    this._userRepository,
  ) : super(const HomeState());

  Future<void> initialize() async {
    final Stream<String?> loggedUserId$ = _authRepository.loggedUserId$;
    await for (final loggedUserId in loggedUserId$) {
      if (loggedUserId == null) {
        emit(state.copyWith(
          status: HomeStateStatus.loggedUserDoesNotExist,
        ));
      } else {
        await _initializeLoggedUser(loggedUserId);
      }
    }
  }

  Future<void> _initializeLoggedUser(String loggedUserId) async {
    final Stream<User?> loggedUser$ =
        _userRepository.getUserById(userId: loggedUserId);
    await for (final loggedUser in loggedUser$) {
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
}
