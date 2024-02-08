import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';
import '../../../../model/user.dart';
import 'sign_in_state.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  @override
  SignInState build() => const SignInStateInitial();

  Future<void> signInWithGoogle() async {
    state = const SignInStateLoading();
    final User? user = await ref.read(authServiceProvider).signInWithGoogle();
    if (user != null) {
      state = const SignInStateUserIsSignedIn();
    }
  }
}
