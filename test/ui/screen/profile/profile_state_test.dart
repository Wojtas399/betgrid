import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/screen/profile/cubit/profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = ProfileState(
        status: ProfileStateStatus.loading,
        avatarUrl: null,
        username: null,
        themeMode: null,
        themePrimaryColor: null,
      );

      const defaultState = ProfileState();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'status.isLoading',
    () {
      test(
        'should return true if status is set as loading',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.loading,
          );

          expect(state.status.isLoading, true);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.completed,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as usernameUpdated',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.usernameUpdated,
          );

          expect(state.status.isLoading, false);
        },
      );

      test(
        'should return false if status is set as newUsernameIsAlreadyTaken',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.newUsernameIsAlreadyTaken,
          );

          expect(state.status.isLoading, false);
        },
      );
    },
  );

  group(
    'status.isUsernameUpdated',
    () {
      test(
        'should return true if status is set as usernameUpdated',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.usernameUpdated,
          );

          expect(state.status.isUsernameUpdated, true);
        },
      );

      test(
        'should return false if status is set as loading',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.loading,
          );

          expect(state.status.isUsernameUpdated, false);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.completed,
          );

          expect(state.status.isUsernameUpdated, false);
        },
      );

      test(
        'should return false if status is set as newUsernameIsAlreadyTaken',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.newUsernameIsAlreadyTaken,
          );

          expect(state.status.isUsernameUpdated, false);
        },
      );
    },
  );

  group(
    'status.isNewUsernameAlreadyTaken',
    () {
      test(
        'should return true if status is set as newUsernameIsAlreadyTaken',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.newUsernameIsAlreadyTaken,
          );

          expect(state.status.isNewUsernameAlreadyTaken, true);
        },
      );

      test(
        'should return false if status is set as loading',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.loading,
          );

          expect(state.status.isNewUsernameAlreadyTaken, false);
        },
      );

      test(
        'should return false if status is set as completed',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.completed,
          );

          expect(state.status.isNewUsernameAlreadyTaken, false);
        },
      );

      test(
        'should return false if status is set as usernameUpdated',
        () {
          const state = ProfileState(
            status: ProfileStateStatus.usernameUpdated,
          );

          expect(state.status.isNewUsernameAlreadyTaken, false);
        },
      );
    },
  );

  group(
    'copyWith status',
    () {
      ProfileState state = const ProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          const ProfileStateStatus newValue = ProfileStateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final ProfileStateStatus currentValue = state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );

  group(
    'copyWith avatarUrl',
    () {
      ProfileState state = const ProfileState();

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

  group(
    'copyWith username',
    () {
      ProfileState state = const ProfileState();

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
    'copyWith themeMode',
    () {
      ProfileState state = const ProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          const ThemeMode newValue = ThemeMode.dark;

          state = state.copyWith(themeMode: newValue);

          expect(state.themeMode, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final ThemeMode? currentValue = state.themeMode;

          state = state.copyWith();

          expect(state.themeMode, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(themeMode: null);

          expect(state.themeMode, null);
        },
      );
    },
  );

  group(
    'copyWith themePrimaryColor',
    () {
      ProfileState state = const ProfileState();

      test(
        'should set new value if passed value is not null',
        () {
          const ThemePrimaryColor newValue = ThemePrimaryColor.yellow;

          state = state.copyWith(themePrimaryColor: newValue);

          expect(state.themePrimaryColor, newValue);
        },
      );

      test(
        'should not change current value if passed value is not specified',
        () {
          final ThemePrimaryColor? currentValue = state.themePrimaryColor;

          state = state.copyWith();

          expect(state.themePrimaryColor, currentValue);
        },
      );

      test(
        'should set null if passed value is null',
        () {
          state = state.copyWith(themePrimaryColor: null);

          expect(state.themePrimaryColor, null);
        },
      );
    },
  );
}
