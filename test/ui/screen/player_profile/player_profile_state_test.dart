import 'package:betgrid/ui/screen/player_profile/cubit/player_profile_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'isLoading, '
    'should be true if status is set as loading',
    () {
      const state = PlayerProfileState(
        status: PlayerProfileStateStatus.loading,
      );

      expect(state.isLoading, true);
    },
  );

  test(
    'isLoading, '
    'should be true if status is set as completed',
    () {
      const state = PlayerProfileState(
        status: PlayerProfileStateStatus.completed,
      );

      expect(state.isLoading, false);
    },
  );
}
