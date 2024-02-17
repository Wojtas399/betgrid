import 'package:betgrid/auth/auth_service_impl.dart';
import 'package:betgrid/firebase/service/firebase_auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/firebase/mock_firebase_auth_service.dart';

void main() {
  final firebaseAuthService = MockFirebaseAuthService();
  late AuthServiceImpl serviceImpl;

  setUpAll(() {
    GetIt.instance.registerFactory<FirebaseAuthService>(
      () => firebaseAuthService,
    );
  });

  setUp(() {
    serviceImpl = AuthServiceImpl();
  });

  tearDown(() {
    reset(firebaseAuthService);
  });

  test(
    'loggedUserId, '
    'should emit id of logged user got from firebase',
    () {
      const String id = 'u1';
      firebaseAuthService.mockGetLoggedUserId(id);

      final Stream<String?> loggedUserId$ = serviceImpl.loggedUserId$;

      expect(loggedUserId$, emits(id));
    },
  );

  test(
    'signInWithGoogle, '
    'user does not exist, '
    'should return null',
    () async {
      firebaseAuthService.mockSignInWithGoogle(null);

      final String? userId = await serviceImpl.signInWithGoogle();

      expect(userId, null);
    },
  );

  test(
    'signInWithGoogle, '
    'user exists, '
    'should return user id',
    () async {
      const String expectedUserId = 'u1';
      firebaseAuthService.mockSignInWithGoogle(expectedUserId);

      final String? userId = await serviceImpl.signInWithGoogle();

      expect(userId, expectedUserId);
    },
  );
}
