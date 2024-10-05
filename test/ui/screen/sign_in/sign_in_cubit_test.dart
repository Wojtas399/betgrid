import 'package:betgrid/model/auth_state.dart';
import 'package:betgrid/ui/screen/sign_in/cubit/sign_in_cubit.dart';
import 'package:betgrid/ui/screen/sign_in/cubit/sign_in_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';

void main() {
  final authRepository = MockAuthRepository();

  SignInCubit createCubit() => SignInCubit(authRepository);

  tearDown(() {
    reset(authRepository);
  });

  group(
    'initialize, ',
    () {
      tearDown(() {
        verify(() => authRepository.authState$).called(1);
      });

      blocTest(
        'should emit state with status set to userIsAlreadySignedIn if auth '
        'state is set to AuthStateUserIsSignedIn',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetAuthState(
          authState: const AuthStateUserIsSignedIn(),
        ),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const SignInState(
            status: SignInStateStatus.userIsAlreadySignedIn,
          ),
        ],
      );

      blocTest(
        'should emit state with status set to completed if auth state is set '
        'to AuthStateUserIsSignedOut',
        build: () => createCubit(),
        setUp: () => authRepository.mockGetAuthState(
          authState: const AuthStateUserIsSignedOut(),
        ),
        act: (cubit) async => await cubit.initialize(),
        expect: () => [
          const SignInState(
            status: SignInStateStatus.completed,
          ),
        ],
      );
    },
  );

  blocTest(
    'signInWithGoogle, '
    'should call method from AuthRepository to sign in with google',
    build: () => createCubit(),
    setUp: () => authRepository.mockSignInWithGoogle(),
    act: (cubit) async => await cubit.signInWithGoogle(),
    expect: () => [
      const SignInState(
        status: SignInStateStatus.loading,
      ),
    ],
    verify: (_) => verify(authRepository.signInWithGoogle).called(1),
  );
}
