import 'package:jlogical_utils/src/pond/context/app_context.dart';
import 'package:jlogical_utils/src/pond/context/module/app_module.dart';

abstract class AuthService extends AppModule {
  /// Returns the user that is currently logged in or null if no one is.
  Future<String?> getCurrentlyLoggedInUserId();

  /// Logs in with [email] and [password].
  /// Returns the user id associated with the logged-in account.
  /// Can throw [LoginFailure]
  Future<String> login({required String email, required String password});

  /// Signs up with [email] and [password].
  /// Returns the newly created user's id.
  /// Can throw [SignupFailure].
  Future<String> signup({required String email, required String password});

  /// Logs in with [phoneNumber]. Creates a new account if one doesn't exist already.
  ///
  /// A verification code is sent to the phone. To confirm the code, [smsCodeGetter] is called.
  /// It should return the verification code the user types in, or null if the user cancelled the verification.
  Future<String> loginWithPhoneNumber({
    required String phoneNumber,
    required Future<String?> Function() smsCodeGetter,
  });

  /// Logs out of the currently logged-in user.
  Future<void> logout();

  /// Deletes the currently logged-in account.
  Future<void> deleteCurrentAccount();

  Future<void> onReset(AppContext context) async {
    await logout();
  }
}
