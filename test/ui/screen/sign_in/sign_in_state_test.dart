import 'package:betgrid/ui/screen/sign_in/cubit/sign_in_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = SignInState(
        status: SignInStateStatus.loading,
      );

      const state = SignInState();

      expect(state, expectedDefaultState);
    },
  );

  test(
    'isUserAlreadySignedIn, '
    'status is set to userIsAlreadySignedIn, '
    'should be true',
    () {
      const state = SignInState(
        status: SignInStateStatus.userIsAlreadySignedIn,
      );

      expect(state.isUserAlreadySignedIn, true);
    },
  );

  test(
    'isUserAlreadySignedIn, '
    'status is not set to loading, '
    'should be false',
    () {
      const state = SignInState(
        status: SignInStateStatus.loading,
      );

      expect(state.isUserAlreadySignedIn, false);
    },
  );

  test(
    'isUserAlreadySignedIn, '
    'status is not set to completed, '
    'should be false',
    () {
      const state = SignInState(
        status: SignInStateStatus.completed,
      );

      expect(state.isUserAlreadySignedIn, false);
    },
  );
}
