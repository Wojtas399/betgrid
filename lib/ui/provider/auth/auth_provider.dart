import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';
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
        final String? userId =
            await ref.read(authServiceProvider).signInWithGoogle();
        return userId != null
            ? const AuthStateUserIsSignedIn()
            : const AuthStateComplete();
      },
    );
  }
}
