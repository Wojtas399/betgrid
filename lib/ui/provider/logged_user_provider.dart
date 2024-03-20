import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth/auth_repository.dart';
import '../../data/repository/user/user_repository.dart';
import '../../model/user.dart';

part 'logged_user_provider.g.dart';

@riverpod
Stream<User?> loggedUser(LoggedUserRef ref) async* {
  final Stream<String?> loggedUserId$ =
      ref.watch(authRepositoryProvider).loggedUserId$;
  await for (final loggedUserId in loggedUserId$) {
    if (loggedUserId == null) {
      yield null;
    } else {
      final Stream<User?> loggedUser$ =
          ref.watch(userRepositoryProvider).getUserById(userId: loggedUserId);
      await for (final loggedUser in loggedUser$) {
        yield loggedUser;
      }
    }
  }
}
