import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/controller/theme_primary_color_controller.dart';
import 'package:betgrid/ui/provider/logged_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/data/repository/mock_user_repository.dart';
import '../../mock/listener.dart';

void main() {
  final userRepository = MockUserRepository();

  ProviderContainer makeProviderContainer({User? loggedUser}) {
    final container = ProviderContainer(
      overrides: [
        loggedUserProvider.overrideWith((_) => Future.value(loggedUser)),
        userRepositoryProvider.overrideWithValue(userRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  tearDown(() {
    reset(userRepository);
  });

  test(
    'build, '
    'logged user does not exist, '
    'should emit ThemePrimaryColor.defaultRed',
    () async {
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.defaultRed;
      final container = makeProviderContainer(loggedUser: null);
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themePrimaryColorControllerProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'build, '
    'should get logged user data from its provider and emit its theme primary color',
    () async {
      const String loggedUserId = 'u1';
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.purple;
      final container = makeProviderContainer(
        loggedUser: createUser(
          id: loggedUserId,
          themePrimaryColor: expectedThemePrimaryColor,
        ),
      );
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await expectLater(
        container.read(themePrimaryColorControllerProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
    },
  );

  test(
    'changeThemePrimaryColor, '
    'logged user does not exist, '
    'should only update theme mode in state',
    () async {
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.pink;
      final container = makeProviderContainer(loggedUser: null);
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(themePrimaryColorControllerProvider.future);
      container
          .read(themePrimaryColorControllerProvider.notifier)
          .changeThemePrimaryColor(expectedThemePrimaryColor);

      await expectLater(
        container.read(themePrimaryColorControllerProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(ThemePrimaryColor.defaultRed),
            ),
        () => listener(
              const AsyncData<ThemePrimaryColor>(ThemePrimaryColor.defaultRed),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verifyNever(
        () => userRepository.updateUserData(
          userId: any(named: 'userId'),
          themePrimaryColor: expectedThemePrimaryColor,
        ),
      );
    },
  );

  test(
    'changeThemePrimaryColor, '
    'logged user exists, '
    'should update theme primary color in state and should call method from '
    "UserRepository to update user's data with new theme primary color",
    () async {
      const String loggedUserId = 'u1';
      const ThemePrimaryColor expectedThemePrimaryColor =
          ThemePrimaryColor.pink;
      userRepository.mockUpdateUserData();
      final container = makeProviderContainer(
        loggedUser: createUser(
          id: loggedUserId,
          themePrimaryColor: ThemePrimaryColor.defaultRed,
        ),
      );
      final listener = Listener<AsyncValue<ThemePrimaryColor>>();
      container.listen(
        themePrimaryColorControllerProvider,
        listener.call,
        fireImmediately: true,
      );

      await container.read(themePrimaryColorControllerProvider.future);
      container
          .read(themePrimaryColorControllerProvider.notifier)
          .changeThemePrimaryColor(expectedThemePrimaryColor);

      await expectLater(
        container.read(themePrimaryColorControllerProvider.future),
        completion(expectedThemePrimaryColor),
      );
      verifyInOrder([
        () => listener(
              null,
              const AsyncLoading<ThemePrimaryColor>(),
            ),
        () => listener(
              const AsyncLoading<ThemePrimaryColor>(),
              const AsyncData<ThemePrimaryColor>(ThemePrimaryColor.defaultRed),
            ),
        () => listener(
              const AsyncData<ThemePrimaryColor>(ThemePrimaryColor.defaultRed),
              const AsyncData<ThemePrimaryColor>(expectedThemePrimaryColor),
            ),
      ]);
      verifyNoMoreInteractions(listener);
      verify(
        () => userRepository.updateUserData(
          userId: loggedUserId,
          themePrimaryColor: expectedThemePrimaryColor,
        ),
      ).called(1);
    },
  );
}
