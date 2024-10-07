import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../model/auth_state.dart';
import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(
    this._authRepository,
  ) : super(const SignInStateCompleted());

  Future<void> initialize() async {
    final Stream<AuthState> authState$ = _authRepository.authState$;
    await for (final authState in authState$) {
      emit(
        authState is AuthStateUserIsSignedIn
            ? const SignInStateUserIsAlreadySignedIn()
            : const SignInStateCompleted(),
      );
    }
  }

  Future<void> signInWithGoogle() async {
    emit(const SignInStateLoading());
    await _authRepository.signInWithGoogle();
  }
}
