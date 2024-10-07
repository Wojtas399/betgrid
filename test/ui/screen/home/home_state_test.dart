import 'package:betgrid/ui/screen/home/cubit/home_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = HomeState(
        status: HomeStateStatus.loading,
        username: null,
        avatarUrl: null,
      );

      const defaultState = HomeState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoggedUserDataNotCompleted, ',
    () {
      test(
        'should be true if status is set as loggedUserDataNotCompleted',
        () {
          const state = HomeState(
            status: HomeStateStatus.loggedUserDataNotCompleted,
          );

          expect(state.status.isLoggedUserDataNotCompleted, true);
        },
      );

      test(
        'should be false if status is set as loading',
        () {
          const state = HomeState(
            status: HomeStateStatus.loading,
          );

          expect(state.status.isLoggedUserDataNotCompleted, false);
        },
      );

      test(
        'should be false if status is set as completed',
        () {
          const state = HomeState(
            status: HomeStateStatus.completed,
          );

          expect(state.status.isLoggedUserDataNotCompleted, false);
        },
      );

      test(
        'should be false if status is set as loggedUserDoesNotExist',
        () {
          const state = HomeState(
            status: HomeStateStatus.loggedUserDoesNotExist,
          );

          expect(state.status.isLoggedUserDataNotCompleted, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      HomeState state = const HomeState();

      test(
        'should set new value if passed value is not null',
        () {
          const HomeStateStatus newValue = HomeStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final HomeStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith username',
    () {
      HomeState state = const HomeState();

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
          final String? currentValue = state.username;

          state = state.copyWith();

          expect(state.username, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(username: null);

          expect(state.username, null);
        },
      );
    },
  );

  group(
    'copyWith avatarUrl',
    () {
      HomeState state = const HomeState();

      test(
        'should set new value if passed value is not null',
        () {
          const String newValue = 'avatar/url';

          state = state.copyWith(avatarUrl: newValue);

          expect(state.avatarUrl, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final String? currentValue = state.avatarUrl;

          state = state.copyWith();

          expect(state.avatarUrl, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(avatarUrl: null);

          expect(state.avatarUrl, null);
        },
      );
    },
  );
}
