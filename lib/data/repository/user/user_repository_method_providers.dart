import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/user.dart';
import 'user_repository.dart';

part 'user_repository_method_providers.g.dart';

@riverpod
Stream<User?> user(
  UserRef ref, {
  required String userId,
}) =>
    ref.watch(userRepositoryProvider).getUserById(userId: userId);
