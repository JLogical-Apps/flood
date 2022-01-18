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

  /// Logs out of the currently logged-in user.
  Future<void> logout();

  Future<void> onReset() async {
    await logout();
  }
}
