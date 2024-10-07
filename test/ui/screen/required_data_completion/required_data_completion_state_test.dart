import 'package:betgrid/ui/screen/required_data_completion/cubit/required_data_completion_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = RequiredDataCompletionState(
        status: RequiredDataCompletionStateStatus.completed,
        avatarImgPath: null,
        username: '',
      );

      const defaultState = RequiredDataCompletionState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading',
    () {
      test(
        'should be true if status is set as loading',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should be false if status is set as usernameIsEmpty',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsEmpty,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should be false if status is set as usernameIsAlreadyTaken',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsAlreadyTaken,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should be false if status is set as dataSaved',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.dataSaved,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'status.isUsernameEmpty',
    () {
      test(
        'should be true if status is set as usernameIsEmpty',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsEmpty,
          );

          expect(state.status.isUsernameEmpty, true);
        },
      );

      test(
        'should be false if status is set as loading',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.loading,
          );

          expect(state.status.isUsernameEmpty, false);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.completed,
          );

          expect(state.status.isUsernameEmpty, false);
        },
      );

      test(
        'should be false if status is set as usernameIsAlreadyTaken',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsAlreadyTaken,
          );

          expect(state.status.isUsernameEmpty, false);
        },
      );

      test(
        'should be false if status is set as dataSaved',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.dataSaved,
          );

          expect(state.status.isUsernameEmpty, false);
        },
      );
    },
  );

  group(
    'status.isUsernameAlreadyTaken',
    () {
      test(
        'should be true if status is set as usernameIsAlreadyTaken',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsAlreadyTaken,
          );

          expect(state.status.isUsernameAlreadyTaken, true);
        },
      );

      test(
        'should be false if status is set as loading',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.loading,
          );

          expect(state.status.isUsernameAlreadyTaken, false);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.completed,
          );

          expect(state.status.isUsernameAlreadyTaken, false);
        },
      );

      test(
        'should be false if status is set as usernameIsEmpty',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsEmpty,
          );

          expect(state.status.isUsernameAlreadyTaken, false);
        },
      );

      test(
        'should be false if status is set as dataSaved',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.dataSaved,
          );

          expect(state.status.isUsernameAlreadyTaken, false);
        },
      );
    },
  );

  group(
    'status.hasDataBeenSaved',
    () {
      test(
        'should be true if status is set as dataSaved',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.dataSaved,
          );

          expect(state.status.hasDataBeenSaved, true);
        },
      );

      test(
        'should be false if status is set as loading',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.loading,
          );

          expect(state.status.hasDataBeenSaved, false);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.completed,
          );

          expect(state.status.hasDataBeenSaved, false);
        },
      );

      test(
        'should be false if status is set as usernameIsEmpty',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsEmpty,
          );

          expect(state.status.hasDataBeenSaved, false);
        },
      );

      test(
        'should be false if status is set as usernameIsAlreadyTaken',
        () {
          const state = RequiredDataCompletionState(
            status: RequiredDataCompletionStateStatus.usernameIsAlreadyTaken,
          );

          expect(state.status.hasDataBeenSaved, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      RequiredDataCompletionState state = const RequiredDataCompletionState();

      test(
        'should set new value if passed value is not null',
        () {
          const RequiredDataCompletionStateStatus newValue =
              RequiredDataCompletionStateStatus.usernameIsEmpty;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final RequiredDataCompletionStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith avatarImgPath',
    () {
      RequiredDataCompletionState state = const RequiredDataCompletionState();

      test(
        'should set new value if passed value is not null',
        () {
          const String newValue = 'avatar/img/path';

          state = state.copyWith(avatarImgPath: newValue);

          expect(state.avatarImgPath, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final String? currentValue = state.avatarImgPath;

          state = state.copyWith();

          expect(state.avatarImgPath, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(avatarImgPath: null);

          expect(state.avatarImgPath, null);
        },
      );
    },
  );

  group(
    'copyWith username',
    () {
      RequiredDataCompletionState state = const RequiredDataCompletionState();

      test(
        'should set new value if passed value is not null',
        () {
          const String newValue = 'username';

          state = state.copyWith(username: newValue);

          expect(state.username, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final String currentValue = state.username;

          state = state.copyWith();

          expect(state.username, currentValue);
        },
      );
    },
  );
}
