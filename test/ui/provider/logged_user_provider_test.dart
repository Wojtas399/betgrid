import 'package:betgrid/data/repository/auth/auth_repository_method_providers.dart';
import 'package:betgrid/data/repository/user/user_repository_method_providers.dart';
import 'package:betgrid/model/user.dart';
import 'package:betgrid/ui/provider/logged_user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../creator/user_creator.dart';

void main() {
  const String loggedUserId = 'u1';

  ProviderContainer makeProviderContainer({
    String? loggedUserId,
    User? loggedUser,
  }) {
    final container = ProviderContainer(
      overrides: [
        loggedUserIdProvider.overrideWith((_) => Stream.value(loggedUserId)),
        if (loggedUserId != null)
          userProvider(userId: loggedUserId).overrideWith(
            (_) => Stream.value(loggedUser),
          ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test(
    'build, '
    'logged user id is null'
    'should emit null',
    () async {
      final container = makeProviderContainer();

      final User? loggedUser = await container.read(loggedUserProvider.future);

      expect(loggedUser, null);
    },
  );

  test(
    'build, '
    'should emit logged user data',
    () async {
      final User expectedLoggedUser = createUser(
        id: loggedUserId,
        username: 'username',
      );
      final container = makeProviderContainer(
        loggedUserId: loggedUserId,
        loggedUser: expectedLoggedUser,
      );

      final User? loggedUser = await container.read(loggedUserProvider.future);

      expect(loggedUser, expectedLoggedUser);
    },
  );
}
