import 'package:betgrid/data/repository/auth/auth_repository.dart';
import 'package:betgrid/ui/provider/logged_user_id_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mock/data/repository/mock_auth_repository.dart';

void main() {
  test(
    'should return id of logged user got directly from AuthRepository',
    () async {
      const String expectedLoggedUserId = 'u1';
      final authRepository = MockAuthRepository();
      final container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
      );
      authRepository.mockGetLoggedUserId(expectedLoggedUserId);

      final String? loggedUserId =
          await container.read(loggedUserIdProvider.future);

      expect(loggedUserId, expectedLoggedUserId);
      verify(() => authRepository.loggedUserId$).called(1);
    },
  );
}
