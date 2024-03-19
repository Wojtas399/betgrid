import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repository/auth/auth_repository.dart';

part 'logged_user_id_provider.g.dart';

@riverpod
Stream<String?> loggedUserId(LoggedUserIdRef ref) =>
    ref.watch(authRepositoryProvider).loggedUserId$;
