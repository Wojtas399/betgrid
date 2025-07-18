import 'package:flutter_test/flutter_test.dart';
import 'package:betgrid_admin/ui/screen/{{screen_name.snakeCase()}}/cubit/{{screen_name.snakeCase()}}_state.dart';

void main() {
  test(
    'default state',
    () {
      const expectedDefaultState = {{screen_name.pascalCase()}}State(
        status: {{screen_name.pascalCase()}}StateStatus.initial,
      );

      const defaultState = {{screen_name.pascalCase()}}State();

      expect(defaultState, expectedDefaultState);
    },
  );

  group(
    'copyWith status',
        () {
      {{screen_name.pascalCase()}}State state =
      const {{screen_name.pascalCase()}}State();

      test(
        'should set new value if it has been passed',
            () {
          const {{screen_name.pascalCase()}}StateStatus newValue =
          {{screen_name.pascalCase()}}StateStatus.completed;

          state = state.copyWith(status: newValue);

          expect(state.status, newValue);
        },
      );

      test(
        'should not change current value if new value has not been passed',
            () {
          final {{screen_name.pascalCase()}}StateStatus currentValue =
              state.status;

          state = state.copyWith();

          expect(state.status, currentValue);
        },
      );
    },
  );
}
