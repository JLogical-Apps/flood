import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_failure.freezed.dart';

@freezed
class SignupFailure with _$SignupFailure {
  const factory SignupFailure.invalidEmail() = InvalidEmailSignupFailure;

  const factory SignupFailure.emailAlreadyUsed() = EmailAlreadyUsedSignupFailure;

  const factory SignupFailure.weakPassword() = WeakPasswordSignupFailure;

  const factory SignupFailure.other() = OtherSignupFailure;
}
