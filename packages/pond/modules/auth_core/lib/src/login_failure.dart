abstract class LoginFailure {
  String get displayText;

  static LoginFailure invalidEmail() => InvalidEmailLoginFailure();

  static LoginFailure userDisabled() => UserDisabledLoginFailure();

  static LoginFailure userNotFound() => UserNotFoundLoginFailure();

  static LoginFailure wrongPassword() => WrongPasswordLoginFailure();

  static LoginFailure passwordResetRequired() => PasswordResetRequiredLoginFailure();
}

class InvalidEmailLoginFailure implements LoginFailure {
  @override
  String get displayText => 'Invalid Email!';
}

class UserDisabledLoginFailure implements LoginFailure {
  @override
  String get displayText => 'Invalid Email!';
}

class UserNotFoundLoginFailure implements LoginFailure {
  @override
  String get displayText => 'Cannot find account with this email and password!';
}

class WrongPasswordLoginFailure implements LoginFailure {
  @override
  String get displayText => 'Cannot find account with this email and password!';
}

class PasswordResetRequiredLoginFailure implements LoginFailure {
  @override
  String get displayText => 'You must reset your password!';
}
