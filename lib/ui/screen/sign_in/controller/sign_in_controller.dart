import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';
import '../../../../model/user.dart';
import '../state/sign_in_state.dart';

part 'sign_in_controller.g.dart';

@riverpod
class SignInController extends _$SignInController {
  @override
  Future<SignInState> build() async {
    final User? loggedUser =
        await ref.read(authServiceProvider).loggedUser$.first;
    return loggedUser != null
        ? const SignInStateUserIsSignedIn()
        : const SignInStateComplete();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final User? user =
            await ref.read(authServiceProvider).signInWithGoogle();
        return user != null
            ? const SignInStateUserIsSignedIn()
            : const SignInStateComplete();
      },
    );
  }
}
