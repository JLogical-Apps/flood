import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';

import '../logging/default_logging_module.dart';
import 'auth_service.dart';
import 'login_failure.dart';
import 'password_resettable.dart';
import 'signup_failure.dart';

class FirebaseAuthService extends AuthService implements PasswordResettable {
  static late final firebase.FirebaseAuth auth = firebase.FirebaseAuth.instance;

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

  @override
  Future<void> deleteCurrentAccount() async {
    final firebaseUser = auth.currentUser;
    await firebaseUser?.delete();

    await logout();
  }

  @override
  Future<void> onResetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  /// Follow the directions on https://firebase.google.com/docs/auth/flutter/phone-auth to set the app up.
  @override
  Future<String> loginWithPhoneNumber({
    required String phoneNumber,
    required Future<String?> Function(SmsCodeRequestType requestType) smsCodeGetter,
  }) async {
    if (kIsWeb) {
      var successfulLogin = false;
      var smsRequestType = SmsCodeRequestType.first;
      do {
        final confirmation = await auth.signInWithPhoneNumber(phoneNumber);
        final smsCode = await smsCodeGetter(smsRequestType);
        if (smsCode == null) {
          throw Exception('Phone Number verification was cancelled.');
        }
        try {
          final credentials = await confirmation.confirm(smsCode);
          final user = credentials.user ?? (throw Exception('Error when signing in with verification code.'));
          return user.uid;
        } catch (e) {
          logError(e);
          smsRequestType = SmsCodeRequestType.retry;
        }
      } while (!successfulLogin);
    } else {
      final userCompleter = Completer<firebase.User>();
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          final result = await auth.signInWithCredential(credential);
          userCompleter.complete(result.user ?? (throw Exception('Cannot login with user from verification code.')));
        },
        verificationFailed: (error) => throw error,
        codeSent: (verificationId, resendToken) async {
          var successfulLogin = false;
          var smsRequestType = SmsCodeRequestType.first;
          do {
            try {
              final smsCode = await smsCodeGetter(smsRequestType);
              if (smsCode == null) {
                userCompleter.completeError(Exception('SMS Code is empty.'));
                return;
              }

              final credentials = await auth.signInWithCredential(
                  firebase.PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode));
              userCompleter
                  .complete(credentials.user ?? (throw Exception('Cannot login with user from verification code.')));
              successfulLogin = true;
            } catch (e) {
              logError(e);
              smsRequestType = SmsCodeRequestType.retry;
            }
          } while (!successfulLogin);
        },
        codeAutoRetrievalTimeout: (id) {
          throw Exception('Automatic SMS verification timed-out. Please try again later.');
        },
      );
      final user = await userCompleter.future;
      return user.uid;
    }
  }

  @override
  Future<void> onChangePassword(String password) async {
    await auth.currentUser!.updatePassword(password);
  }
}
