import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  late final FirebaseAuth _auth;
  late final GoogleSignIn _googleSignIn;

  FirebaseService() {
    _auth = FirebaseAuth.instance;
    _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
  }

  Future<GoogleSignInAccount?> handleSignIn() async {
    try {
      return await _googleSignIn.signIn();
    } catch (error) {
      throw error.toString();
    }
  }

  Future<UserCredential?> signInwithGoogle() async {
    try {
      final signin = await handleSignIn();
      final GoogleSignInAuthentication? googleSignInAuthentication = await signin?.authentication;
      if (googleSignInAuthentication != null) {
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        return await _auth.signInWithCredential(credential);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      Get.defaultDialog(title: 'erro', middleText: e.message!);
      rethrow;
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> createUserWithEmailAndPassword(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<void> resetPasswordEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
