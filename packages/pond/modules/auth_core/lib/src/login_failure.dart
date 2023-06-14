abstract class LoginFailure {
  static LoginFailure invalidEmail() => InvalidEmailLoginFailure();

  static LoginFailure userDisabled() => UserDisabledLoginFailure();

  static LoginFailure userNotFound() => UserNotFoundLoginFailure();

  static LoginFailure wrongPassword() => WrongPasswordLoginFailure();
}

class InvalidEmailLoginFailure implements LoginFailure {}

class UserDisabledLoginFailure implements LoginFailure {}

class UserNotFoundLoginFailure implements LoginFailure {}

class WrongPasswordLoginFailure implements LoginFailure {}
