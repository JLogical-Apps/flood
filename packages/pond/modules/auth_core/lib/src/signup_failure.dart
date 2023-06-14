abstract class SignupFailure {
  static SignupFailure invalidEmail() => InvalidEmailSignupFailure();

  static SignupFailure emailAlreadyUsed() => EmailAlreadyUsedSignupFailure();

  static SignupFailure weakPassword() => WeakPasswordSignupFailure();
}

class InvalidEmailSignupFailure implements SignupFailure {}

class EmailAlreadyUsedSignupFailure implements SignupFailure {}

class WeakPasswordSignupFailure implements SignupFailure {}
