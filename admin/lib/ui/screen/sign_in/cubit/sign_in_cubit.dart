import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../model/auth_state.dart';
import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(this._authRepository) : super(const SignInState());

  Future<void> initialize() async {
    final Stream<AuthState> authState$ = _authRepository.authState$;
    await for (final authState in authState$) {
      emit(
        state.copyWith(
          status:
              authState is AuthStateUserIsSignedIn
                  ? SignInStateStatus.userIsAlreadySignedIn
                  : SignInStateStatus.completed,
        ),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: SignInStateStatus.loading));
    await _authRepository.signInWithGoogle();
  }
}
