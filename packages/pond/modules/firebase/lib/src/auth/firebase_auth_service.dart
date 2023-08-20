import 'package:auth_core/auth_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FirebaseAuthService with IsAuthService, IsCorePondComponent {
  late final FirebaseAuth auth = FirebaseAuth.instance;

  late final BehaviorSubject<FutureValue<String?>> _userIdX =
      BehaviorSubject.seeded(FutureValue.loaded(auth.currentUser?.uid));

  @override
  Future<String> login(String email, String password) async {
    try {
      final credentials = await auth.signInWithEmailAndPassword(email: email, password: password);
      final userId = credentials.user!.uid;
      _userIdX.value = FutureValue.loaded(userId);
      return userId;
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
      final userId = credential.user!.uid;
      _userIdX.value = FutureValue.loaded(userId);
      return userId;
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
    _userIdX.value = FutureValue.loaded(null);
  }

  @override
  ValueStream<FutureValue<String?>> get userIdX => _userIdX;
}
