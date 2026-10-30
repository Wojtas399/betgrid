import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {
  static final Future<void> _googleSignInInitialized =
      GoogleSignIn.instance.initialize();

  Stream<String?> get loggedUserId$ =>
      FirebaseAuth.instance.authStateChanges().map((User? user) => user?.uid);

  Future<void> signInWithGoogle() async {
    await _googleSignInInitialized;
    final GoogleSignInAccount googleUser;
    try {
      googleUser = await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (exception) {
      if (exception.code == GoogleSignInExceptionCode.canceled) return;
      rethrow;
    }
    final OAuthCredential authCredential = GoogleAuthProvider.credential(
      idToken: googleUser.authentication.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(authCredential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
