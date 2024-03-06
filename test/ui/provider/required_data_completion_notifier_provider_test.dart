import 'package:betgrid/auth/auth_service.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/ui/provider/notifier/required_data_completion/required_data_completion_notifier_provider.dart';
import 'package:betgrid/ui/provider/notifier/required_data_completion/required_data_completion_notifier_provider_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/auth/mock_auth_service.dart';
import '../../mock/data/repository/mock_user_repository.dart';
import '../../mock/listener.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
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
      final listener = Listener<RequiredDataCompletionNotifierState>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );

      container
          .read(requiredDataCompletionNotifierProvider.notifier)
          .updateAvatarImgPath(avatarImgPath);

      verifyInOrder([
        () => listener(
              null,
              const RequiredDataCompletionNotifierState(),
            ),
        () => listener(
              const RequiredDataCompletionNotifierState(),
              const RequiredDataCompletionNotifierState(
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
      final listener = Listener<RequiredDataCompletionNotifierState>();
      container.listen(
        requiredDataCompletionNotifierProvider,
        listener,
        fireImmediately: true,
      );

      container
          .read(requiredDataCompletionNotifierProvider.notifier)
          .updateUsername(username);

      verifyInOrder([
        () => listener(
              null,
              const RequiredDataCompletionNotifierState(),
            ),
        () => listener(
              const RequiredDataCompletionNotifierState(),
              const RequiredDataCompletionNotifierState(username: username),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );
}
