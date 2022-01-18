import 'package:firebase_auth/firebase_auth.dart' as firebase;

import 'auth_service.dart';
import 'login_failure.dart';
import 'signup_failure.dart';

class FirebaseAuthService extends AuthService {
  static final firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;

  @override
  Future<String?> getCurrentlyLoggedInUserId() async {
    return auth.currentUser?.uid;
  }

  @override
  Future<String> login({required String email, required String password}) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      return credentials.user!.uid;
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw LoginFailure.invalidEmail();
        case 'user-disabled':
          throw LoginFailure.userDisabled();
        case 'user-not-found':
          throw LoginFailure.userNotFound();
        case 'wrong-password':
          throw LoginFailure.wrongPassword();
        default:
          throw e;
      }
    }
  }

  @override
  Future<String> signup({required String email, required String password}) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid;
    } on firebase.FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw SignupFailure.emailAlreadyUsed();
        case 'invalid-email':
          throw SignupFailure.invalidEmail();
        case 'operation-not-allowed':
          throw SignupFailure.other();
        case 'weak-password':
          throw SignupFailure.weakPassword();
        default:
          throw e;
      }
    }
  }

  @override
  Future<void> logout() {
    return auth.signOut();
  }
}
