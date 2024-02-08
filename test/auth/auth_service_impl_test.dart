import 'package:betgrid/auth/auth_service_impl.dart';
import 'package:betgrid/firebase/model/user_dto/user_dto.dart';
import 'package:betgrid/firebase/service/firebase_auth_service.dart';
import 'package:betgrid/model/user.dart';
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
    'loggedUser, '
    'should emit data about logged user from firebase',
    () {
      const String id = 'u1';
      const String email = 'user@example.com';
      const UserDto userDto = UserDto(id: id, email: email);
      const User expectedUser = User(id: id, email: email);
      firebaseAuthService.mockGetLoggedUser(userDto);

      final Stream<User?> user$ = serviceImpl.loggedUser$;

      expect(user$, emits(expectedUser));
    },
  );

  test(
    'signInWithGoogle, '
    'user does not exist, '
    'should return null',
    () async {
      firebaseAuthService.mockSignInWithGoogle(null);

      final User? user = await serviceImpl.signInWithGoogle();

      expect(user, null);
    },
  );

  test(
    'signInWithGoogle, '
    'user exists, '
    'should return user data',
    () async {
      const String id = 'u1';
      const String email = 'user@example.com';
      const UserDto userDto = UserDto(id: id, email: email);
      const User expectedUser = User(id: id, email: email);
      firebaseAuthService.mockSignInWithGoogle(userDto);

      final User? user = await serviceImpl.signInWithGoogle();

      expect(user, expectedUser);
    },
  );
}
