import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../model/auth_state.dart';
import 'auth_repository.dart';

part 'auth_repository_method_providers.g.dart';

@riverpod
Stream<AuthState> authState(AuthStateRef ref) =>
    ref.watch(authRepositoryProvider).authState$;

@riverpod
Stream<String?> loggedUserId(LoggedUserIdRef ref) =>
    ref.watch(authRepositoryProvider).loggedUserId$;
