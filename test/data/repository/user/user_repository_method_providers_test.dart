import 'package:betgrid/data/repository/user/user_repository.dart';
import 'package:betgrid/data/repository/user/user_repository_method_providers.dart';
import 'package:betgrid/model/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../creator/user_creator.dart';
import '../../../mock/data/repository/mock_user_repository.dart';

void main() {
  final userRepository = MockUserRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        userRepositoryProvider.overrideWithValue(userRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'userProvider, '
    'should get user from UserRepository and should emit it',
    () async {
      const String userId = 'u1';
      final User expectedUser = createUser(id: userId);
      userRepository.mockGetUserById(user: expectedUser);
      final container = makeProviderContainer();

      final User? user = await container.read(
        userProvider(userId: userId).future,
      );

      expect(user, expectedUser);
    },
  );
}
