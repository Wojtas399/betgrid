import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../model/user_dto/user_dto.dart';

@injectable
class FirebaseAuthService {
  Future<UserDto?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    if (googleAuth == null) return null;
    final OAuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential credential =
        await FirebaseAuth.instance.signInWithCredential(authCredential);
    final User? user = credential.user;
    if (user == null) return null;
    return UserDto.fromFirebaseUser(user);
  }
}
