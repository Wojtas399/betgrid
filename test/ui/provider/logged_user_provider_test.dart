import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/provider/logged_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../../creator/user_creator.dart';
import '../../mock/data/repository/mock_auth_repository.dart';
import '../../mock/data/repository/mock_user_repository.dart';

void main() {
  final authRepository = MockAuthRepository();
  final userRepository = MockUserRepository();

  setUpAll(() {
    GetIt.I.registerSingleton<AuthRepository>(authRepository);
    GetIt.I.registerLazySingleton<UserRepository>(() => userRepository);
  });

  tearDown(() {
    reset(authRepository);
    reset(userRepository);
  });

  test(
    'build, '
    'logged user id is null'
    'should emit null',
    () async {
      authRepository.mockGetLoggedUserId(null);
      final container = ProviderContainer();

      final User? loggedUser = await container.read(loggedUserProvider.future);

      expect(loggedUser, null);
    },
  );

  test(
    'build, '
    'should emit logged user data',
    () async {
      const String loggedUserId = 'u1';
      final User expectedLoggedUser = createUser(
        id: loggedUserId,
        username: 'username',
      );
      authRepository.mockGetLoggedUserId(loggedUserId);
      userRepository.mockGetUserById(user: expectedLoggedUser);
      final container = ProviderContainer();

      final User? loggedUser = await container.read(loggedUserProvider.future);

      expect(loggedUser, expectedLoggedUser);
    },
  );
}
