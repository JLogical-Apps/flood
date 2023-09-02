abstract class SignupFailure {
  String get displayText;

  static SignupFailure invalidEmail() => InvalidEmailSignupFailure();

  static SignupFailure emailAlreadyUsed() => EmailAlreadyUsedSignupFailure();

  static SignupFailure weakPassword() => WeakPasswordSignupFailure();
}

class InvalidEmailSignupFailure implements SignupFailure {
  @override
  String get displayText => 'Invalid Email!';
}

class EmailAlreadyUsedSignupFailure implements SignupFailure {
  @override
  String get displayText => 'An account with that email already exists!';
}

class WeakPasswordSignupFailure implements SignupFailure {
  @override
  String get displayText => 'Weak Password!';
}
