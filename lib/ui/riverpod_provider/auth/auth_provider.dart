import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';
import '../../../../model/user.dart';
import 'auth_state.dart';

part 'auth_provider.g.dart';

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState> build() async {
    final String? loggedUserId =
        await ref.read(authServiceProvider).loggedUserId$.first;
    return loggedUserId != null
        ? const AuthStateUserIsSignedIn()
        : const AuthStateComplete();
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        final User? user =
            await ref.read(authServiceProvider).signInWithGoogle();
        return user != null
            ? const AuthStateUserIsSignedIn()
            : const AuthStateComplete();
      },
    );
  }
}
