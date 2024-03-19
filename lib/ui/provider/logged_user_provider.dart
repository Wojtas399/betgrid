import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/repository/auth/auth_repository.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

part 'logged_user_provider.g.dart';

@riverpod
Stream<User?> loggedUser(LoggedUserRef ref) =>
    ref.watch(authRepositoryProvider).loggedUserId$.switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? ref
                  .watch(userRepositoryProvider)
                  .getUserById(userId: loggedUserId)
              : Stream.value(null),
        );
