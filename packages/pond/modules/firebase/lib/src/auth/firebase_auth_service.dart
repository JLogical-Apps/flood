import 'package:auth_core/auth_core.dart';
import 'package:firebase/firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pond_core/pond_core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:utils/utils.dart';

class FirebaseAuthService with IsAuthService, IsCorePondComponent {
  late final FirebaseAuth auth = context.firebaseCoreComponent.auth;

  late final BehaviorSubject<FutureValue<Account?>> _accountX = BehaviorSubject.seeded(FutureValue.empty());

  @override
  List<CorePondComponentBehavior> get behaviors => [
        CorePondComponentBehavior(
          onLoad: (context, _) async {
            final user = auth.currentUser;
            if (user == null) {
              _accountX.value = FutureValue.loaded(null);
              return;
            }

            _accountX.value = FutureValue.loaded(Account(
              accountId: user.uid,
              isAdmin: await user.isAdmin(),
            ));
          },
        ),
      ];

  @override
  Future<Account> login(AuthCredentials credentials) async {
    try {
      final user = await getUserFromCredentials(credentials);

      final account = Account(
        accountId: user.uid,
        isAdmin: await user.isAdmin(),
      );
      _accountX.value = FutureValue.loaded(account);
      return account;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-email':
          throw LoginFailure.invalidEmail();
        case 'user-disabled':
          throw LoginFailure.userDisabled();
        case 'user-not-found':
          throw LoginFailure.userNotFound();
        case 'wrong-password':
        case 'invalid-credential':
          throw LoginFailure.wrongPassword();
        default:
          rethrow;
      }
    }
  }

  @override
  Future<Account> loginWithOtp(OtpProvider otpProvider) {
    throw UnimplementedError();
  }

  @override
  Future<Account> signup(AuthCredentials authCredentials) async {
    try {
      final user = await createUserFromCredentials(authCredentials);

      final account = Account(
        accountId: user.uid,
        isAdmin: await user.isAdmin(),
      );
      _accountX.value = FutureValue.loaded(account);
      return account;
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
    _accountX.value = FutureValue.loaded(null);
  }

  @override
  Future<void> delete() async {
    final user = auth.currentUser;
    if (user == null) {
      throw Exception('Cannot delete an account when you are not logged in!');
    }

    await user.delete();

    await logout();
  }

  @override
  ValueStream<FutureValue<Account?>> get accountX => _accountX;

  Future<User> getUserFromCredentials(AuthCredentials credentials) async {
    if (credentials is EmailAuthCredentials) {
      final credential =
          await auth.signInWithEmailAndPassword(email: credentials.email, password: credentials.password);
      return credential.user!;
    }

    throw UnimplementedError();
  }

  Future<User> createUserFromCredentials(AuthCredentials credentials) async {
    if (credentials is EmailAuthCredentials) {
      final credential =
          await auth.createUserWithEmailAndPassword(email: credentials.email, password: credentials.password);
      return credential.user!;
    }

    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }
}

extension on User {
  Future<bool> isAdmin() async {
    final token = await getIdTokenResult();
    final claims = token.claims ?? {};
    return claims['admin'] == true;
  }
}
