import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/ui/screen/required_data_completion/controller/required_data_completion_controller.dart';
import 'package:betgrid/ui/screen/required_data_completion/controller/required_data_completion_controller_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';
import '../../../mock/data/repository/mock_user_repository.dart';
import '../../../mock/listener.dart';

void main() {
  final authService = MockAuthRepository();
  final userRepository = MockUserRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authService),
        userRepositoryProvider.overrideWithValue(userRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(authService);
    reset(userRepository);
  });

  test(
    'updateAvatarImgPath, '
    'should update avatarImgPath in state',
    () async {
      const String avatarImgPath = 'avatar/path';
      final container = makeProviderContainer();
      final listener = Listener<RequiredDataCompletionControllerState>();
      container.listen(
        requiredDataCompletionControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      container
          .read(requiredDataCompletionControllerProvider.notifier)
          .updateAvatarImgPath(avatarImgPath);

      verifyInOrder([
        () => listener(
              null,
              const RequiredDataCompletionControllerState(),
            ),
        () => listener(
              const RequiredDataCompletionControllerState(),
              const RequiredDataCompletionControllerState(
                avatarImgPath: avatarImgPath,
              ),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'updateUsername, '
    'should update username in state',
    () async {
      const String username = 'username';
      final container = makeProviderContainer();
      final listener = Listener<RequiredDataCompletionControllerState>();
      container.listen(
        requiredDataCompletionControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      container
          .read(requiredDataCompletionControllerProvider.notifier)
          .updateUsername(username);

      verifyInOrder([
        () => listener(
              null,
              const RequiredDataCompletionControllerState(),
            ),
        () => listener(
              const RequiredDataCompletionControllerState(),
              const RequiredDataCompletionControllerState(username: username),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
