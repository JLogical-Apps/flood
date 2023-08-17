import 'package:auth_core/auth_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pond_core/pond_core.dart';

class FirebaseAuthService with IsAuthService, IsCorePondComponent {
  late final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  List<CorePondComponentBehavior> get behaviors =>
      super.behaviors +
      [
        CorePondComponentBehavior(
          onReset: (context, __) async {
            await logout();
          },
        ),
      ];

  @override
  Future<String?> getLoggedInUserId() async {
    return auth.currentUser?.uid;
  }

  @override
  Future<String> login(String email, String password) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      return credentials.user!.uid;
    } on FirebaseAuthException catch (e) {
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
          rethrow;
      }
    }
  }

  @override
  Future<String> signup(String email, String password) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user!.uid;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw SignupFailure.emailAlreadyUsed();
        case 'invalid-email':
          throw SignupFailure.invalidEmail();
        case 'operation-not-allowed':
          rethrow;
        case 'weak-password':
          throw SignupFailure.weakPassword();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<void> logout() async {
    await auth.signOut();
  }
}
