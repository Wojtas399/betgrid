import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth/auth_repository_method_providers.dart';
import '../../data/repository/user/user_repository_method_providers.dart';
import '../../model/user.dart';

part 'logged_user_provider.g.dart';

@riverpod
Future<User?> loggedUser(LoggedUserRef ref) async {
  final String? loggedUserId = await ref.watch(loggedUserIdProvider.future);
  if (loggedUserId == null) return null;
  final User? loggedUser = await ref.watch(
    userProvider(userId: loggedUserId).future,
  );
  return loggedUser;
}
