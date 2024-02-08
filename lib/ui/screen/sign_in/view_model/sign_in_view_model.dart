import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../auth/auth_service.dart';

part 'sign_in_view_model.g.dart';

@riverpod
class SignInViewModel extends _$SignInViewModel {
  @override
  void build() {}

  Future<void> signInWithGoogle() async {
    print('I was here');
    await ref.read(authServiceProvider).signInWithGoogle();
  }
}
