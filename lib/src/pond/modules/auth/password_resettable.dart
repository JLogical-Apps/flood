/// Indicates that an auth service can handle resetting a user's password.
abstract class PasswordResettable {
  /// Sends a password-reset to the [email].
  /// Regardless of whether [email] is a valid email or not, the output is the same.
  Future<void> onResetPassword(String email);
}
