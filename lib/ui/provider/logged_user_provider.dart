import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth/auth_repository.dart';
import '../../data/repository/user/user_repository_method_providers.dart';
import '../../dependency_injection.dart';
import '../../model/user.dart';

part 'logged_user_provider.g.dart';

@riverpod
Future<User?> loggedUser(LoggedUserRef ref) async {
  final String? loggedUserId =
      await getIt.get<AuthRepository>().loggedUserId$.first;
  if (loggedUserId == null) return null;
  return await ref.watch(
    userProvider(userId: loggedUserId).future,
  );
}
