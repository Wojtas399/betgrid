import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../data/repository/auth/auth_repository.dart';
import '../../../../model/auth_state.dart';
import 'sign_in_state.dart';

@injectable
class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;
  StreamSubscription<AuthState>? _authStateListener;

  SignInCubit(this._authRepository) : super(const SignInStateCompleted());

  @override
  Future<void> close() {
    _authStateListener;
    return super.close();
  }

  void initialize() {
    _authStateListener ??= _authRepository.authState$.listen((
      AuthState authState,
    ) {
      emit(
        authState is AuthStateUserIsSignedIn
            ? const SignInStateUserIsAlreadySignedIn()
            : const SignInStateCompleted(),
      );
    });
  }

  Future<void> signInWithGoogle() async {
    emit(const SignInStateLoading());
    await _authRepository.signInWithGoogle();
  }
}
