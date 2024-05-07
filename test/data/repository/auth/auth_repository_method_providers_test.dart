import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/data/repository/auth/auth_repository_method_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mock/data/repository/mock_auth_repository.dart';

void main() {
  final authRepository = MockAuthRepository();

  ProviderContainer makeProviderContainer() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'loggedUserIdProvider, '
    'should get logged user id from AuthRepository and should emit it',
    () async {
      const String expectedLoggedUserId = 'u1';
      authRepository.mockGetLoggedUserId(expectedLoggedUserId);
      final container = makeProviderContainer();

      final String? loggedUserId = await container.read(
        loggedUserIdProvider.future,
      );

      expect(loggedUserId, expectedLoggedUserId);
    },
  );
}
