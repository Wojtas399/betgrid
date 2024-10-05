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

  group(
    'isUserAlreadySignedIn, ',
    () {
      test(
        'should be true if status is set to userIsAlreadySignedIn',
        () {
          const state = SignInState(
            status: SignInStateStatus.userIsAlreadySignedIn,
          );

          expect(state.isUserAlreadySignedIn, true);
        },
      );

      test(
        'should be false if status is set to loading',
        () {
          const state = SignInState(
            status: SignInStateStatus.loading,
          );

          expect(state.isUserAlreadySignedIn, false);
        },
      );

      test(
        'should be false if status is set to completed',
        () {
          const state = SignInState(
            status: SignInStateStatus.completed,
          );

          expect(state.isUserAlreadySignedIn, false);
        },
      );
    },
  );
}
